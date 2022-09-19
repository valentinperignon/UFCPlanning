//
//  Group.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation
import RealmSwift

public enum GroupType: Int, PersistableEnum {
    case category = 1
    case final = 2
    case ancestorLink = 3
}

public class Group: Object {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var name: String
    @Persisted public var type: GroupType
    @Persisted public var isVisible: Bool

    public static let main = Group(id: 0, name: "Tous les groupes", type: .category)
    
    public convenience init(id: Int, name: String, type: GroupType) {
        self.init()
        self.id = id
        self.name = name
        self.type = type
        self.isVisible = true
    }
}
