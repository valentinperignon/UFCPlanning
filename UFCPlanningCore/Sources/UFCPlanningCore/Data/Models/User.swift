//
//  User.swift
//  
//
//  Created by Valentin Perignon on 04/09/2022.
//

import Foundation
import RealmSwift

public class User: Object {
    @Persisted public var id: Int
    @Persisted public var name: String
    public var token: String?
    
    public convenience init(id: Int, name: String, token: String?) {
        self.init()
        self.id = id
        self.name = name
        self.token = token
    }
}
