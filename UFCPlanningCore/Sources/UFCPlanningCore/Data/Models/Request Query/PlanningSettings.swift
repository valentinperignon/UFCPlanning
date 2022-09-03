//
//  PlanningSettings.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public struct PlanningSettings {
    public let numberOfDays: Int
    public let mode: PlanningMode
    public let withColors: Bool
    public let withSports: Bool
    public let withExtra: Bool
    public let studentId: Int
    public let token: String
    
    public init(numberOfDays: Int,
                mode: PlanningMode,
                withColors: Bool,
                withSports: Bool,
                withExtra: Bool,
                studentId: Int,
                token: String) {
        self.numberOfDays = numberOfDays
        self.mode = mode
        self.withColors = withColors
        self.withSports = withSports
        self.withExtra = withExtra
        self.studentId = studentId
        self.token = token
    }
}
