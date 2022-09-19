//
//  GroupsViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 19/09/2022.
//

import Foundation
import UFCPlanningCore

@MainActor class GroupsViewModel {
    let planningManager: PlanningManager = PlanningManager.shared

    let parent: Group

    var isLoading = false
    var groups = [Group]()

    init(parent: Group = .main) {
        self.parent = parent
    }

    func fetchGroups() async throws {
        isLoading = true
        groups = try await planningManager.apiFetcher.groups(with: parent.id)
        if groups.first?.type == .ancestorLink {
            groups.removeFirst()
        }
        isLoading = false
    }
}
