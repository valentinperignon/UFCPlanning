//
//  SettingsViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 12/09/2022.
//

import Foundation
import SFSafeSymbols
import UIKit

struct SettingsSection: Equatable {
    let id: Int
    let name: String
    let items: [SettingsItem]

    static let account = SettingsSection(id: 0, name: "Compte", items: [.account])
    static let plannings = SettingsSection(id: 1, name: "Plannings", items: [.plannings])
    static let about = SettingsSection(id: 2, name: "Autres", items: [.visibility, .campusSport, .homeworkAlerts])

    static func == (lhs: SettingsSection, rhs: SettingsSection) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SettingsItem {
    let icon: SFSymbol
    let name: String

    static let account = SettingsItem(icon: .personCropCircle, name: "Mon compte")

    static let plannings = SettingsItem(icon: .calendar, name: "Plannings")

    static let visibility = SettingsItem(icon: .eyes, name: "Visibilité")
    static let campusSport = SettingsItem(icon: .figureWalk, name: "Activités Campus Sport")
    static let homeworkAlerts = SettingsItem(icon: .bell, name: "Alertes pour les devoirs")
}

class SettingsViewModel {
    let settings: [SettingsSection]

    init() {
        settings = [.account, .plannings, .about]
    }
}