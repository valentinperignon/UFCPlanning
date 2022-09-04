//
//  ApiFetcher.swift
//  
//
//  Created by Valentin Perignon on 25/08/2022.
//

import Foundation

public class ApiFetcher {
    private let urlSession: URLSession
    
    private let planingDecoder: PlanningDecoder
    private let trainingsDecoder: TrainingsDecoder
    
    public init() {
        urlSession = URLSession(configuration: .default)
        planingDecoder = PlanningDecoder()
        trainingsDecoder = TrainingsDecoder()
    }
    
    public func trainings(with id: Int) async throws -> [Training] {
        let (data, _) = try await urlSession.data(endpoint: .trainings(with: 0))
        
        guard let dataString = String(data: data, encoding: .isoLatin1) else {
            throw ApiError.cannotDecodeData
        }
        return trainingsDecoder.decode(from: dataString)
    }
    
    public func planning(for training: Training, with settings: PlanningSettings, user: User) async throws -> Planning {
        let (data, _) = try await urlSession.data(endpoint: .planning(for: training.id, with: settings, for: user))
        
        guard let dataString = String(data: data, encoding: .isoLatin1) else {
            throw ApiError.cannotDecodeData
        }
        let days = planingDecoder.decode(from: dataString)
        return Planning(trainingId: training.id, days: days)
    }
}
