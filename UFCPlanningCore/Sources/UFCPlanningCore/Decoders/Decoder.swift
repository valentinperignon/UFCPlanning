//
//  Decoder.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public protocol Decoder {
    associatedtype DataOutput
    func decode(from data: String) -> DataOutput
}
