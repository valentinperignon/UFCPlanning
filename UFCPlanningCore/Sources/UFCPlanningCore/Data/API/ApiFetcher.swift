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
    private let groupsDecoder: GroupsDecoder
    
    public init() {
        urlSession = URLSession(configuration: .default)
        planingDecoder = PlanningDecoder()
        groupsDecoder = GroupsDecoder()
    }
    
    public func groups(with id: Int) async throws -> [Group] {
        let (data, _) = try await urlSession.data(endpoint: .groups(with: 0))
        
        guard let dataString = String(data: data, encoding: .isoLatin1) else {
            throw ApiError.cannotDecodeData
        }
        return groupsDecoder.decode(from: dataString)
    }
    
    public func planning(for groups: [Group], with settings: PlanningSettings, user: User? = nil) async throws -> Planning {
        let (data, _) = try await urlSession.data(endpoint: .planning(for: groups.map(\.id), with: settings, for: user))
        
        guard let dataString = String(data: data, encoding: .isoLatin1) else {
            throw ApiError.cannotDecodeData
        }
        return Planning(days: planingDecoder.decode(from: dataString))
    }
}
