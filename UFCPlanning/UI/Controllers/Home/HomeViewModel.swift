//
//  HomeViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 07/09/2022.
//

import Foundation
import UFCPlanningCore
import RealmSwift

class DaySection {
    let date: Date
    var lessons: [Lesson]

    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
        self.lessons = []
    }
}

@MainActor class HomeViewModel {
    var planningManager: PlanningManager

    var planning: [DaySection]
    var filteredPlanning: [DaySection]

    var onListUpdate: (() -> Void)?
    var endRefreshingList: (() -> Void)?

    private var observationToken: NotificationToken?

    init() {
        planningManager = PlanningManager.shared

        planning = [DaySection]()
        filteredPlanning = [DaySection]()

        observeLessons()
    }

    func fetchPlanning() async {
        do {
            try await planningManager.planning()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    @objc func refreshPlanning() {
        Task {
            await fetchPlanning()
            self.endRefreshingList?()
        }
    }

    func getDay(at section: Int, filtered: Bool) -> DaySection {
        return filtered ? filteredPlanning[section] : planning[section]
    }

    func getLesson(at indexPath: IndexPath, filtered: Bool) -> Lesson {
        let day = getDay(at: indexPath.section, filtered: filtered)
        return day.lessons[indexPath.item]
    }

    func updateSearchResults(for text: String) async {
        let result = planningManager.searchInPlanning(for: text)
        filteredPlanning = splitLessonsIntoSections(AnyRealmCollection(result))
        onListUpdate?()
    }

    // MARK: - Private methods

    private func observeLessons() {
        let realm = planningManager.getRealm()
        let fetchedLessons = AnyRealmCollection(realm.objects(Lesson.self).sorted(by: \.start))

        observationToken = fetchedLessons.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case let .initial(lessons):
                self.planning = self.splitLessonsIntoSections(lessons)
                self.onListUpdate?()
            case let .update(lessons, _, _, _):
                self.planning = self.splitLessonsIntoSections(lessons)
                self.onListUpdate?()
            case let .error(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func splitLessonsIntoSections(_ lessons: AnyRealmCollection<Lesson>) -> [DaySection] {
        var sections = [DaySection]()

        var currentSection: DaySection?
        for lesson in lessons {
            if currentSection == nil {
                currentSection = DaySection(date: lesson.start)
            }
            if !Calendar.current.isDate(lesson.start, inSameDayAs: currentSection!.date) {
                sections.append(currentSection!)
                currentSection = DaySection(date: lesson.start)
            }

            currentSection!.lessons.append(lesson)
        }
        if let currentSection = currentSection {
            sections.append(currentSection)
        }

        return sections
    }
}
