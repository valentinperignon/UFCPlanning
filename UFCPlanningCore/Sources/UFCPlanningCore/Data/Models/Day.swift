//
//  Day.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class Day {
    let date: Date
    let subjects: [Subject]
    
    init(date: Date, subjects: [Subject]) {
        self.date = date
        self.subjects = subjects
    }
}
