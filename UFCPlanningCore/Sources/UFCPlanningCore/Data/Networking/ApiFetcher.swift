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
    
    public func trainings(with id: Int) async throws -> [Training] {
        let (data, _) = try await urlSession.data(endpoint: .trainings(with: 0))
        
        guard let dataString = String(data: data, encoding: .isoLatin1) else {
            // TODO: Throw error
            fatalError()
        }
        let parser = TrainingsParser(input: dataString)
        return parser.parse()
    }
    
    public func planning(for training: Training, with settings: PlanningSettings) async throws -> Planning {
        let (data, _) = try await urlSession.data(endpoint: .planning(for: settings.id,
                                                                      numberOdDays: settings.numberOfDays,
                                                                      mode: settings.mode,
                                                                      withColor: settings.withColors,
                                                                      withSports: settings.withSports,
                                                                      withExtra: settings.withExtra,
                                                                      studentId: settings.studentId,
                                                                      token: settings.token))
        
        guard let dataString = String(data: data, encoding: .isoLatin1) else {
            // TODO: Throw error
            fatalError()
        }
        let parser = PlanningParser(input: dataString, training: training)
        return parser.parse()
    }
}
