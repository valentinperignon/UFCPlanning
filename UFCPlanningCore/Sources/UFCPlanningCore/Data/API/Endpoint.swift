//
//  Endpoint.swift
//  
//
//  Created by Valentin Perignon on 25/08/2022.
//

import Foundation

public struct Endpoint {
    public let path: String
    public let queryItems: [URLQueryItem]?
    
    public var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "sedna.univ-fcomte.fr"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            fatalError("Invalid endpoint url: \(self)")
        }
        return url
    }
    
    public init(path: String, queryItems: [URLQueryItem]? = nil) {
        self.path = path
        self.queryItems = queryItems
    }
    
    public func append(path: String, queryItems: [URLQueryItem]? = nil) -> Endpoint {
        return Endpoint(path: "\(self.path)\(path)", queryItems: queryItems)
    }
}

extension Endpoint {
    static let base = Endpoint(path: "/jsp/custom/ufc")
    
    static func groups(with id: Int) -> Endpoint {
        .base.append(path: "/wmselect.jsp", queryItems: [URLQueryItem(name: "id", value: "\(id)")])
    }
    
    static func planning(for groupId: Int, with settings: PlanningSettings, for user: User?) -> Endpoint {
        .base.append(path: "/wmplanif.jsp", queryItems: [
            URLQueryItem(name: "id", value: "\(groupId)"),
            URLQueryItem(name: "jours", value: "\(settings.numberOfDays)"),
            URLQueryItem(name: "mode", value: "\(settings.mode.rawValue)"),
            URLQueryItem(name: "color", value: settings.withColors ? "1" : "0"),
            URLQueryItem(name: "sports", value: settings.withSports ? "O" : "N"),
            URLQueryItem(name: "extra", value: settings.withExtra ? "O" : "N"),
            URLQueryItem(name: "idetu", value: "\(user?.id ?? 0)"),
            URLQueryItem(name: "connexion", value: user?.token)
        ])
    }
}

