//
//  UIColor+Decimal.swift
//  
//
//  Created by Valentin Perignon on 03/09/2022.
//

import UIKit

extension UIColor {
    convenience init(decimal: Int) {
        let red = CGFloat((decimal >> 16) & 0xFF) / CGFloat(255)
        let green = CGFloat((decimal >> 8) & 0xFF) / CGFloat(255)
        let blue = CGFloat(decimal & 0xFF) / CGFloat(255)

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
