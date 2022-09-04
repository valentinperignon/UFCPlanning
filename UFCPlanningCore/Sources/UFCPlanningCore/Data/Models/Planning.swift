//
//  Planning.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class Planning {
    public let trainingId: Int
    public let days: [Day]
    
    public init(trainingId: Int, days: [Day]) {
        self.trainingId = trainingId
        self.days = days
    }
}
