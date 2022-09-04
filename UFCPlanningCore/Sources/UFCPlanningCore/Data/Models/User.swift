//
//  User.swift
//  
//
//  Created by Valentin Perignon on 04/09/2022.
//

import Foundation

public class User {
    public let id: Int
    public let name: String
    public let token: String?
    
    public init(id: Int, name: String, token: String?) {
        self.id = id
        self.name = name
        self.token = token
    }
}
