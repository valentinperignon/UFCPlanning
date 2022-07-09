//
//  Day.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 09/07/2022.
//

import RealmSwift
import Foundation

class Day: EmbeddedObject {
    @Persisted var date: Date
    @Persisted var subjects: List<Subject>
}
