//
//  Subject.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation
import UIKit

public class Subject {
    let name: String
    let interval: DateInterval
    let about: String
    let color: UIColor
    
    public init(name: String, interval: DateInterval, about: String, color: UIColor) {
        self.name = name
        self.interval = interval
        self.about = about
        self.color = color
    }
}
