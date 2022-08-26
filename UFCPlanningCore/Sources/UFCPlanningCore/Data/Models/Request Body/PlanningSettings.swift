//
//  PlanningSettings.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public struct PlanningSettings {
    let id: Int
    let numberOfDays: Int
    let mode: PlanningMode
    let withColors: Bool
    let withSports: Bool
    let withExtra: Bool
    let studentId: Int
    let token: String
}
