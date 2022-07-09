//
//  Subject.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 09/07/2022.
//

import RealmSwift
import Foundation

class Subject: EmbeddedObject {
    @Persisted var name: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var place: String?
    @Persisted var color: Int?
}
