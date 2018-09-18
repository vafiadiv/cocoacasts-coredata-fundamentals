//
//  Note.swift
//  Notes
//
//  Created by Valentin Vafiadi on 19/09/2018.
//  Copyright © 2018 VFD Design. All rights reserved.
//

import Foundation

extension Note {
    var updatedAtAsDate: Date {
        return updatedAt ?? Date()
    }
    
    var createdAtAsDate: Date {
        return createdAt ?? Date()
    }
}
