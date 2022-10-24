//
//  SettingsViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 12/09/2022.
//

import Foundation
import UFCPlanningCore
import RealmSwift
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

    static let account = SettingsRow(id: 0, icon: .personCropCircle, name: L10n.Localizable.Settings.Row.login)

    static let plannings = SettingsRow(id: 1, icon: .calendar, name: L10n.Localizable.Settings.Row.addGroup)

    static let visibility = SettingsRow(id: 2, icon: .eyes, name: L10n.Localizable.Settings.Row.numberOfDays, userDefaultsKey: "daysNumber")
    static let campusSport = SettingsRow(id: 3, icon: .figureWalk, name: L10n.Localizable.Settings.Row.campus, userDefaultsKey: "campusSport")
    static let homeworkAlerts = SettingsRow(id: 4, icon: .bell, name: L10n.Localizable.Settings.Row.homework, userDefaultsKey: "homeworkAlert")

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
    let planningManager = PlanningManager.shared
    let settings: [SettingsSection] = [.account, .plannings, .about]

    var groups = [Group]()
    var observationToken: NotificationToken?

    var updateList: (([Int], [Int], [Int], Bool) -> Void)?

    var isUserConnected: Bool {
        planningManager.user != nil
    }

    init() {
        observeGroups()
    }

    func observeGroups() {
        let realm = planningManager.getRealm()
        let fetchedGroups = realm.objects(Group.self)

        observationToken = fetchedGroups.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case let .initial(groups):
                self.groups = Array(groups)
                self.updateList?([], [], [], true)
            case let .update(groups, deletions, insertions, modifications):
                self.groups = Array(groups)
                self.updateList?(deletions, insertions, modifications, false)
            case let .error(error):
                print("Error while observing groups: \(error.localizedDescription)")
            }
        }
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
