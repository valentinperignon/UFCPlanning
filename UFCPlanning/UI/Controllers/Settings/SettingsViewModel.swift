//
//  SettingsViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 12/09/2022.
//

import Foundation
import UFCPlanningCore
import SFSafeSymbols
import UIKit

struct SettingsSection: Equatable {
    let id: Int
    let items: [SettingsItem]

    static let account = SettingsSection(id: 0, items: [.account])
    static let plannings = SettingsSection(id: 1, items: [.plannings])
    static let about = SettingsSection(id: 2, items: [.visibility, .campusSport, .homeworkAlerts])

    static func ==(lhs: SettingsSection, rhs: SettingsSection) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SettingsItem: Equatable {
    let id: Int
    let icon: SFSymbol
    let name: String

    static let account = SettingsItem(id: 0, icon: .personCropCircle, name: "Se connecter")

    static let plannings = SettingsItem(id: 1, icon: .calendar, name: "Ajouter un groupe")

    static let visibility = SettingsItem(id: 2, icon: .eyes, name: "Visibilité")
    static let campusSport = SettingsItem(id: 3, icon: .figureWalk, name: "Activités Campus Sport")
    static let homeworkAlerts = SettingsItem(id: 4, icon: .bell, name: "Alertes pour les devoirs")

    static func ==(lhs: SettingsItem, rhs: SettingsItem) -> Bool {
        return lhs.id == rhs.id
    }
}

class SettingsViewModel {
    let planningManager: PlanningManager
    let settings: [SettingsSection]

    var isUserConnected: Bool {
        planningManager.user != nil
    }

    init() {
        planningManager = PlanningManager.shared
        settings = [.account, .plannings, .about]
    }

    func connectUser(login: String, password: String) async throws {
        guard planningManager.user == nil else { return }
        try await planningManager.saveUser(login: login, password: password)
    }

    func disconnectUser() throws {
        guard planningManager.user != nil else { return }
        try planningManager.removeUser()
    }
}
