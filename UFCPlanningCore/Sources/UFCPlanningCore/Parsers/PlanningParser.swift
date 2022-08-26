//
//  PlanningParser.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class PlanningParser: Parser {
    private let input: String
    private let training: Training
    
    init(input: String, training: Training) {
        self.input = input
        self.training = training
    }
    
    public func parse() -> Planning {
        // TODO: Parse Planning
        return Planning(training: training, days: [])
    }
}
