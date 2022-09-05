//
//  Planning.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation
import RealmSwift

public class Planning: Object {
    @Persisted public var days: List<Day>
    
    public convenience init(days: [Day]) {
        self.init()
        self.days = List()
        self.days.append(objectsIn: days)
    }
}
