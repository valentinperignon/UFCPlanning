//
//  Entity.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 09/07/2022.
//

import RealmSwift

class Entity: Object {
    @Persisted var level: Int
    @Persisted var name: String
    @Persisted var parent: String
}
