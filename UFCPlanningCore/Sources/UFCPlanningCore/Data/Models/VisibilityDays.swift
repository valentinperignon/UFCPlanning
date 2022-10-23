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
            return NSLocalizedString("visibilityDays.oneWeek", bundle: .module, comment: "")
        case .twoWeeks:
            return NSLocalizedString("visibilityDays.twoWeeks", bundle: .module, comment: "")
        case .oneMonth:
            return NSLocalizedString("visibilityDays.oneMonth", bundle: .module, comment: "")
        case .twoMonths:
            return NSLocalizedString("visibilityDays.twoMonths", bundle: .module, comment: "")
        }
    }
}
