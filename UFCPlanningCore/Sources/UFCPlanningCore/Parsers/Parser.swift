//
//  File.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public protocol Parser {
    associatedtype DataOutput
    func parse() -> DataOutput
}
