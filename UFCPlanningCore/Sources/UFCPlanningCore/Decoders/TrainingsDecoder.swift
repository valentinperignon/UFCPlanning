//
//  TrainigsDecoder.swift
//  
//
//  Created by Valentin Perignon on 26/08/2022.
//

import Foundation

public class TrainingsDecoder: Decoder {
    public func decode(from data: String) -> [Training] {
        // TODO: Parse Trainings
        return [Training(id: 0, name: "", isShown: true)]
    }
}
