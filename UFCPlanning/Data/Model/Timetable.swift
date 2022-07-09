//
//  Timetable.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 09/07/2022.
//

import RealmSwift

class Timetable: Object {
    @Persisted var entityName: String
    @Persisted var days: List<Day>
    @Persisted var isVisible: Bool
}
