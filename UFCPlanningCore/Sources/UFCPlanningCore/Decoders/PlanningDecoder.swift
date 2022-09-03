//
//  PlanningDecoder.swift
//
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation
import UIKit

public class PlanningDecoder: Decoder {
    private let breakCharacter: Character = ";"
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "E d MMMM"
        formatter.defaultDate = .now
        return formatter
    }()
    
    public func decode(from data: String) -> [Day] {
        let days = data.components(separatedBy: "*date*;").filter { $0 != "\r\n" }
        
        var parsedDays = [Day]()
        for day in days {
            var items = day.split(whereSeparator: \.isNewline)
            guard let currentDate = formatDate(from: String(items.removeFirst())) else { break }
            
            var subjects = [Subject]()
            for item in items {
                let elements = item.components(separatedBy: ";")
                guard elements.count >= 3, let decimalColor = Int(elements[0]) else { break }
                let color = UIColor(decimal: decimalColor)
                let (interval, title) = formatHoursAndTitle(from: elements[1], for: currentDate)
                let room = elements[2]
                
                let subject = Subject(name: title, interval: interval, about: room, color: color)
                subjects.append(subject)
            }
            
            parsedDays.append(Day(date: currentDate, subjects: subjects))
        }
        
        return parsedDays
    }
    
    private func formatDate(from stringDate: String) -> Date? {
        if stringDate == "Aujourd'hui" {
            return Calendar.current.startOfDay(for: .now)
        }
        if stringDate == "Demain" {
            return .now
        }
        return dateFormatter.date(from: stringDate)
    }
    
    private func formatHoursAndTitle(from info: String, for day: Date) -> (DateInterval, String) {
        let elements = info.components(separatedBy: " : ")
        
        let hours = elements[0].components(separatedBy: "-")
        var interval = [Date]()
        for hour in hours {
            let timeComponents = hour.split(separator: "h")
            guard timeComponents.count >= 1,
                  let hour = Int(timeComponents[0]),
                  let minutes = timeComponents.count == 2 ? Int(timeComponents[1]) : 0,
                  let date = Calendar.current.date(bySettingHour: hour, minute: minutes, second: 0, of: day)
            else { break }
            interval.append(date)
        }
        
        return (DateInterval(start: interval[0], end: interval[1]), elements[1])
    }
}
