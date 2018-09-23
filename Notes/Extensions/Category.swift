//
//  Category.swift
//  Notes
//
//  Created by Valentin Vafiadi on 24/09/2018.
//  Copyright © 2018 VFD Design. All rights reserved.
//

import Foundation
import UIKit

extension Category {
    var color: UIColor? {
        get {
            guard let hex = colorAsHex else { return nil }
            return UIColor(hex: hex)
        }
        
        set {
            if let newColor = newValue {
                colorAsHex = newColor.toHex
            }
        }
    }
}
