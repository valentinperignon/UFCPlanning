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
    let date: Date
    let about: String
    let color: UIColor
    
    init(name: String, date: Date, about: String, color: UIColor) {
        self.name = name
        self.date = date
        self.about = about
        self.color = color
    }
}
