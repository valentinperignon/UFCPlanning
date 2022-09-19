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
            return "Aucune alarme"
        case .oneHourBefore:
            return "1 heure avant"
        case .twoHoursBefore:
            return "2 heures avant"
        case .oneDayBefore:
            return "1 jour avant"
        case .twoDaysBefore:
            return "2 jours avant"
        }
    }
}
