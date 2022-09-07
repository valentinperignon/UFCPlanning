//
//  HomeViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 07/09/2022.
//

import Foundation
import UFCPlanningCore
import RealmSwift

class HomeViewModel {
    var planningManager: PlanningManager
    var planning: AnyRealmCollection<Day>

    private var observationToken: NotificationToken?

    init(planningManager: PlanningManager) {
        self.planningManager = planningManager
        planning = AnyRealmCollection(List<Day>())

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
            // TODO: Stop refreshing
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
