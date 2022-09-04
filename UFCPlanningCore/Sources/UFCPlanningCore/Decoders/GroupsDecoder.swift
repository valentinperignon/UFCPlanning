//
//  GroupsDecoder.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class GroupsDecoder: Decoder {
    private let breakCharacter: Character = ";"
    private let ancestorSign = ".."
    
    public func decode(from data: String) -> [Group] {
        let list = data.split(whereSeparator: \.isNewline)
        return list.compactMap(transform)
    }
    
    private func transform(sequence: String.SubSequence) -> Group? {
        let items = sequence.split(separator: breakCharacter)
        
        guard items.count >= 3,
              let id = Int(items[1]),
              let typeRawValue = Int(items[0]),
              let type = GroupType(rawValue: typeRawValue)
        else { return nil }
        
        let name = String(items[2])
        return Group(id: id, name: name, type: name == ancestorSign ? .ancestorLink : type)
    }
}
