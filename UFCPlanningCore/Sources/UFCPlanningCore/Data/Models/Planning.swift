//
//  Planning.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class Planning {
    let training: Training
    let days: [Day]
    
    init(training: Training, days: [Day]) {
        self.training = training
        self.days = days
    }
}
