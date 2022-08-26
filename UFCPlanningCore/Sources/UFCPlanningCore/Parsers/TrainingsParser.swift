//
//  File.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class TrainingsParser: Parser {
    private let input: String
    
    init(input: String) {
        self.input = input
    }
    
    public func parse() -> [Training] {
        // TODO: Parse Trainings
        return [Training(id: 0, name: "", isShown: true)]
    }
}
