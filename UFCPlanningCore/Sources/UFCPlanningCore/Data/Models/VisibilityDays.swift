//
//  VisibilityDay.swift
//  
//
//  Created by Valentin Perignon on 17/09/2022.
//

import Foundation

public enum VisibilityDays: Int, SettingsEnum {
    case oneWeek = 7
    case twoWeeks = 14
    case oneMonth = 30
    case twoMonths = 60

    public static var defaultValue = VisibilityDays.twoMonths

    public var description: String {
        switch self {
        case .oneWeek:
            return "1 semaine"
        case .twoWeeks:
            return "2 semaines"
        case .oneMonth:
            return "1 mois"
        case .twoMonths:
            return "2 mois"
        }
    }
}
