//
//  Group.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public enum GroupType: Int {
    case category = 1
    case ancestorLink = 2
    case final = 3
}

public class Group {
    public let id: Int
    public let name: String
    public let type: GroupType
    
    public init(id: Int, name: String, type: GroupType) {
        self.id = id
        self.name = name
        self.type = type
    }
}
