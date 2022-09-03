//
//  Planning.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class Planning {
    public let training: Training!
    public let days: [Day]
    
    public init(training: Training? = nil, days: [Day]) {
        self.training = training
        self.days = days
    }
}
