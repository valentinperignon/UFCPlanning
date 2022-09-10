//
//  HomeViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 07/09/2022.
//

import EventKitUI
import Foundation
import UFCPlanningCore
import RealmSwift

class HomeViewModel {
    var planningManager: PlanningManager
    var planning: AnyRealmCollection<Day>
    var eventStore: EKEventStore

    private var observationToken: NotificationToken?

    init() {
        planningManager = PlanningManager.shared
        planning = AnyRealmCollection(List<Day>())
        eventStore = EKEventStore()

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
            // TODO: Stop view refreshing
        }
    }

    func getSubject(at indexPath: IndexPath) -> Subject {
        let day = planning[indexPath.section]
        return day.subjects[indexPath.item]
    }

    func addHomework(for subject: Subject, delegate: EKEventEditViewDelegate, completion: @escaping (Bool) -> Void, presentView: @escaping (UIViewController) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            guard error == nil && granted else {
                completion(false)
                return
            }

            let event = EKEvent(eventStore: self.eventStore)
            event.title = "[\(subject.name)] "
            event.startDate = subject.start
            event.endDate = subject.end
            event.alarms = [EKAlarm(relativeOffset: EventAlarm.dayBefore.rawValue)]

            DispatchQueue.main.async {
                let eventVC = EKEventEditViewController()
                eventVC.editViewDelegate = delegate
                eventVC.eventStore = self.eventStore
                eventVC.event = event

                presentView(eventVC)
                completion(true)
            }
        }
    }

    private func observeDays() {
        let realm = planningManager.getRealm()
        planning = AnyRealmCollection(realm.objects(Day.self).sorted(by: \.date))

        observationToken = planning.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case let .initial(days):
                self.planning = days
                // TODO: Update tableview
            case let .update(days, _, _, _):
                self.planning = days
                // TODO: Update tableview
            case let .error(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
