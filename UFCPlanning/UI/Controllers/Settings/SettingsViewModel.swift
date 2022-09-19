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
    let items: [SettingsRow]

    static let account = SettingsSection(id: 0, items: [.account])
    static let plannings = SettingsSection(id: 1, items: [.plannings])
    static let about = SettingsSection(id: 2, items: [.visibility, .campusSport, .homeworkAlerts])

    static func ==(lhs: SettingsSection, rhs: SettingsSection) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SettingsRow: Equatable {
    let id: Int
    let icon: SFSymbol
    let name: String
    let userDefaultsKey: String?

    static let account = SettingsRow(id: 0, icon: .personCropCircle, name: "Se connecter")

    static let plannings = SettingsRow(id: 1, icon: .calendar, name: "Ajouter un groupe")

    static let visibility = SettingsRow(id: 2, icon: .eyes, name: "Jours à afficher", userDefaultsKey: "daysNumber")
    static let campusSport = SettingsRow(id: 3, icon: .figureWalk, name: "Activités Campus Sport", userDefaultsKey: "campusSport")
    static let homeworkAlerts = SettingsRow(id: 4, icon: .bell, name: "Alerte pour les devoirs", userDefaultsKey: "homeworkAlert")

    init(id: Int, icon: SFSymbol, name: String, userDefaultsKey: String? = nil) {
        self.id = id
        self.icon = icon
        self.name = name
        self.userDefaultsKey = userDefaultsKey
    }

    static func ==(lhs: SettingsRow, rhs: SettingsRow) -> Bool {
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
