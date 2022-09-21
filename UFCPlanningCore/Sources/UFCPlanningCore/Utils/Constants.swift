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
        start: .now,
        end: .now.addingTimeInterval(3600),
        about: "Salle 42",
        decimalColor: 0
    )

    public static let refreshWidget: TimeInterval = -600 // 10 minutes before
}
