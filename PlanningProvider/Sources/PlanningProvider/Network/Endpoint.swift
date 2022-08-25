//
//  Endpoint.swift
//  
//
//  Created by Valentin Perignon on 23/08/2022.
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
    
    static func trainings(with id: Int) -> Endpoint {
        .base.append(path: "/wmselect.jsp", queryItems: [URLQueryItem(name: "id", value: "\(id)")])
    }
    
    static func planning(for id: Int, numberOdDays: Int, mode: Int, withColor: Bool, withSports: Bool, withExtra: Bool, studentId: Int, token: String) -> Endpoint {
        .base.append(path: "/wmplanif.jsp", queryItems: [
            URLQueryItem(name: "id", value: "\(id)"),
            URLQueryItem(name: "jours", value: "\(numberOdDays)"),
            URLQueryItem(name: "mode", value: "\(mode)"),
            URLQueryItem(name: "color", value: withColor ? "1" : "0"),
            URLQueryItem(name: "sports", value: withSports ? "O" : "N"),
            URLQueryItem(name: "idetu", value: "\(studentId)"),
            URLQueryItem(name: "connexion", value: token)
        ])
    }
}
