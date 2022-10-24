//
//  WidgetError.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 30/09/2022.
//

import Foundation

enum WidgetError: Error {
    case cannotFetchLessons
    case emptyLesson

    var timeToWaitToRefresh: TimeInterval {
        switch self {
        case .cannotFetchLessons:
            return 300 // 5 minutes
        case .emptyLesson:
            return 43200 // 12 hours
        }
    }

    var description: String {
        switch self {
        case .cannotFetchLessons:
            return L10n.Localizable.Widget.Error.network
        case .emptyLesson:
            return L10n.Localizable.Widget.Error.empty
        }
    }
}
