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
        let _ = try await urlSession.data(endpoint: .trainings(with: 0))
        // TODO: Get trainings
    }
    
    public func planning() {
        // TODO: Get planning
    }
}
