//
//  EventAlarm.swift
//  
//
//  Created by Valentin Perignon on 10/09/2022.
//

import Foundation

public protocol SettingsEnum: CaseIterable {
    static var defaultValue: Self { get }
    var description: String { get }
}

public enum EventAlarm: TimeInterval, SettingsEnum {
    case noAlarm = 0
    case oneHourBefore = -3_600
    case twoHoursBefore = -7_200
    case oneDayBefore = -86_400
    case twoDaysBefore = -172_800

    public static var defaultValue = EventAlarm.noAlarm

    public var description: String {
        switch self {
        case .noAlarm:
            return NSLocalizedString("eventalarm_no", comment: "")
        case .oneHourBefore:
            return NSLocalizedString("eventalarm_onehour", comment: "")
        case .twoHoursBefore:
            return NSLocalizedString("eventalarm_twohours", comment: "")
        case .oneDayBefore:
            return NSLocalizedString("eventalarm_oneday", comment: "")
        case .twoDaysBefore:
            return NSLocalizedString("eventalarm_twodays", comment: "")
        }
    }
}
