//
//  PlanningManager.swift
//  
//
//  Created by Valentin Perignon on 04/09/2022.
//

import Foundation

public class PlanningManager {
    public let apiFetcher: ApiFetcher
    
    public init() {
        apiFetcher = ApiFetcher()
    }
    
    public func plannings() async throws -> [Planning] {
        let planning = try await apiFetcher.planning(
            for: Group(id: 15862, name: "", type: .final),
            with: PlanningSettings(numberOfDays: 60, mode: .separatedByDate, withColors: true, withSports: true, withExtra: true)
        )
        return [planning]
    }
}
