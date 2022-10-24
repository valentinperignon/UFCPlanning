//
//  Constants.swift
//  
//
//  Created by Valentin Perignon on 21/09/2022.
//

import Foundation

public struct Constants {
    public static let sharedGroupURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.fr.valentinperignon.UFCPlanning"
    )

    public static let widgetLessonPlaceholder = Lesson(
        name: "Anglais",
        start: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
        end: Calendar.current.date(byAdding: .day, value: 1, to: .now.addingTimeInterval(4000))!,
        about: "Salle 42",
        decimalColor: 0
    )

    public static let refreshWidget: TimeInterval = -1200 // 20 minutes before
}
