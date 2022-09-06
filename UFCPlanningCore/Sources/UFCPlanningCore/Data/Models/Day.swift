//
//  Day.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation
import RealmSwift

public class Day: Object {
    @Persisted public var date: Date
    @Persisted public var subjects: List<Subject>
    
    public convenience init(date: Date, subjects: [Subject]) {
        self.init()
        self.date = date
        self.subjects = List()
        self.subjects.append(objectsIn: subjects)
    }
}
