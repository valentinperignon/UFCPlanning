//
//  ApiFetcher.swift
//  
//
//  Created by Valentin Perignon on 25/08/2022.
//

import Foundation

public final class ApiFetcher {
    private let urlSession: URLSession
    
    public init() {
        urlSession = URLSession(configuration: .default)
    }
    
    public func trainings(with id: Int) async throws {
        let response = try await urlSession.data(endpoint: .trainings(with: 0))
        // TODO: Get trainings
    }
    
    public func planning(with settings: PlanningSettings) async throws {
        let response = try await urlSession.data(endpoint: .planning(for: settings.id,
                                                                     numberOdDays: settings.numberOfDays,
                                                                     mode: settings.mode,
                                                                     withColor: settings.withColors,
                                                                     withSports: settings.withSports,
                                                                     withExtra: settings.withExtra,
                                                                     studentId: settings.studentId,
                                                                     token: settings.token))
        // TODO: Get planning
    }
}
