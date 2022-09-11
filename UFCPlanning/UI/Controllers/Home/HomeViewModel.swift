//
//  HomeViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 07/09/2022.
//

import Foundation
import UFCPlanningCore
import RealmSwift

@MainActor class HomeViewModel {
    var planningManager: PlanningManager

    var planning: AnyRealmCollection<Day>
    var filteredPlanning: [Day]

    var onListUpdate: (() -> Void)?
    var endRefreshingList: (() -> Void)?

    private var observationToken: NotificationToken?

    init() {
        planningManager = PlanningManager.shared

        planning = AnyRealmCollection(List<Day>())
        filteredPlanning = [Day]()

        observeDays()
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

    func getDay(at section: Int, filtered: Bool) -> Day {
        return filtered ? filteredPlanning[section] : planning[section]
    }

    func getSubject(at indexPath: IndexPath, filtered: Bool) -> Subject {
        let day = getDay(at: indexPath.section, filtered: filtered)
        return day.subjects[indexPath.item]
    }

    // MARK: - Private methods

    private func observeDays() {
        let realm = planningManager.getRealm()
        planning = AnyRealmCollection(realm.objects(Day.self).sorted(by: \.date))

        observationToken = planning.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case let .initial(days):
                self.planning = days
                self.onListUpdate?()
            case let .update(days, _, _, _):
                self.planning = days
                self.onListUpdate?()
            case let .error(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
