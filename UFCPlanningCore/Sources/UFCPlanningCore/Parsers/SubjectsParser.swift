//
//  File.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class SubjectsParser: Parser {
    private let input: String
    
    init(input: String) {
        self.input = input
    }
    
    public func parse() -> [Subject] {
        // TODO: Parse Subjects
        return [Subject(name: "", date: .now, about: "", color: .clear)]
    }
}
