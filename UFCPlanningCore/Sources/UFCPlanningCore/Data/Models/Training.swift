//
//  File.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class Training {
    let id: Int
    let name: String
    let isShown: Bool
    
    init(id: Int, name: String, isShown: Bool) {
        self.id = id
        self.name = name
        self.isShown = isShown
    }
}
