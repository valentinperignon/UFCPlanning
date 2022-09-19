//
//  File.swift
//  
//
//  Created by Valentin Perignon on 27/08/2022.
//

import Foundation

public enum ApiError: Error {
    case cannotDecodeData
    case wrongLoginOrPassword
}
