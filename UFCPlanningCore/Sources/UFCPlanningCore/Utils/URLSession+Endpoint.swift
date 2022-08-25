//
//  URLSession+Endpoint.swift
//  
//
//  Created by Valentin Perignon on 25/08/2022.
//

import Foundation

extension URLSession {
    public func data(endpoint: Endpoint) async throws -> (Data, URLResponse) {
        return try await data(from: endpoint.url)
    }
}
