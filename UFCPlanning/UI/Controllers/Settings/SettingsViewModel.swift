//
//  SettingsViewModel.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 12/09/2022.
//

import Foundation
import SFSafeSymbols
import UIKit

class SettingsSection {
    let name: String
    var items: [SettingsItem]

    static let account = SettingsSection(name: "Compte", items: [.account])
    static let plannings = SettingsSection(name: "Plannings", items: [])
    static let about = SettingsSection(name: "À Propos", items: [.visibility, .campusSport, .homeworkAlerts])

    init(name: String, items: [SettingsItem]) {
        self.name = name
        self.items = items
    }
}

class SettingsItem {
    let icon: SFSymbol
    let name: String

    static let account = SettingsItem(icon: .personCropCircle, name: "Mon compte")

    static let plannings = SettingsItem(icon: .calendar, name: "Plannings")

    static let visibility = SettingsItem(icon: .eyes, name: "Visibilité")
    static let campusSport = SettingsItem(icon: .figureWalk, name: "Activités Campus Sport")
    static let homeworkAlerts = SettingsItem(icon: .bell, name: "Alertes pour les devoirs")

    init(icon: SFSymbol, name: String) {
        self.icon = icon
        self.name = name
    }
}

class SettingsViewModel {
    let settings: [SettingsSection]

    init() {
        settings = [.account, .plannings, .about]
    }
}
