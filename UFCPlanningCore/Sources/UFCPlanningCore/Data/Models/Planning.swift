//
//  Planning.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class Planning {
    public let groupId: Int
    public let days: [Day]
    
    public init(groupId: Int, days: [Day]) {
        self.groupId = groupId
        self.days = days
    }
}
