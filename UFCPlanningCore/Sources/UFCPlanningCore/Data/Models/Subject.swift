//
//  Subject.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation
import UIKit
import RealmSwift

public class Subject: EmbeddedObject {
    @Persisted public var name: String
    @Persisted public var start: Date
    @Persisted public var end: Date
    @Persisted public var about: String
    @Persisted public var decimalColor: Int
    
    public var color: UIColor {
        UIColor(decimal: decimalColor)
    }
    
    public convenience init(name: String, start: Date, end: Date, about: String, decimalColor: Int) {
        self.init()
        self.name = name
        self.start = start
        self.end = end
        self.about = about
        self.decimalColor = decimalColor
    }
}
