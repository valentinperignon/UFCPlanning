//
//  PlanningDecoder.swift
//
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation
import UIKit

public class PlanningDecoder: Decoder {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "E d MMMM"
        formatter.defaultDate = .now
        return formatter
    }()
    
    public func decode(from data: String) -> [Lesson] {
        let days = data.components(separatedBy: "*date*;").filter { $0 != "\r\n" }
        
        var parsedLessons = [Lesson]()
        for day in days {
            var items = day.components(separatedBy: "\n")
            guard let currentDate = formatDate(from: items.removeFirst()) else { break }
            
            for item in items {
                let elements = item.components(separatedBy: ";")
                guard elements.count >= 2,
                      let decimalColor = Int(elements[0]),
                      let (start, end, name) = getHoursAndName(from: elements[1], for: currentDate)
                else { continue }
                
                let about = elements.count >= 3 ? elements[2] : nil
                parsedLessons.append(Lesson(name: name, start: start, end: end, about: about, decimalColor: decimalColor))
            }
        }
        return parsedLessons
    }
    
    private func getHoursAndName(from info: String, for day: Date) -> (Date, Date, String)? {
        let elements = info.components(separatedBy: " : ")
        
        let hours = elements[0].components(separatedBy: "-")
        guard hours.count >= 2,
              let start = formatHour(from: hours[0], for: day),
              let end = formatHour(from: hours[1], for: day)
        else { return nil }
        
        return (start, end, elements[1])
    }
    
    private func formatDate(from stringDate: String) -> Date? {
        if stringDate.contains("Aujourd'hui") {
            return Calendar.current.startOfDay(for: .now)
        }
        if stringDate.contains("Demain") {
            let today = Calendar.current.startOfDay(for: .now)
            return Calendar.current.date(byAdding: .day, value: 1, to: today)
        }
        if let date = dateFormatter.date(from: stringDate) {
            return Calendar.current.startOfDay(for: date)
        }
        return nil
    }
    
    private func formatHour(from info: String, for day: Date) -> Date? {
        let timeComponents = info.components(separatedBy: "h").compactMap { Int($0) }
        guard timeComponents.count >= 1 else { return nil }
        
        return Calendar.current.date(
            bySettingHour: timeComponents[0],
            minute: timeComponents.count == 2 ? timeComponents[1] : 0,
            second: 0,
            of: day
        )
    }
}
