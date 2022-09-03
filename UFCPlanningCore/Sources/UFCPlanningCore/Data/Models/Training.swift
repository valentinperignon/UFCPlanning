//
//  File.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public enum TrainingType: Int {
    case category = 1
    case ancestorLink = 2
    case final = 3
}

public class Training {
    public let id: Int
    public let name: String
    public let type: TrainingType
    
    public init(id: Int, name: String, type: TrainingType) {
        self.id = id
        self.name = name
        self.type = type
    }
}
