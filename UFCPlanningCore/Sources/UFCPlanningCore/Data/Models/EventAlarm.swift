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
            return NSLocalizedString("eventAlarm.no", bundle: .module, comment: "")
        case .oneHourBefore:
            return NSLocalizedString("eventAlarm.oneHour", bundle: .module, comment: "")
        case .twoHoursBefore:
            return NSLocalizedString("eventAlarm.twoHours", bundle: .module, comment: "")
        case .oneDayBefore:
            return NSLocalizedString("eventAlarm.oneDay", bundle: .module, comment: "")
        case .twoDaysBefore:
            return NSLocalizedString("eventAlarm.twoDays", bundle: .module, comment: "")
        }
    }
}
