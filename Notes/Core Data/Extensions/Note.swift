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
    
    var alphabetizedTags: [Tag]? {
        guard let tags = self.tags as? Set<Tag> else {
            return nil
        }
        return tags.sorted(by: { (tag0, tag1) -> Bool in
            guard let tag0Name = tag0.name else { return true }
            guard let tag1Name = tag1.name else { return true }
            return tag0Name < tag1Name
        })
    }
    
    var alphabetizedTagsAsString: String? {
        guard let tags = alphabetizedTags, tags.count > 0 else { return nil }
        return tags.compactMap { $0.name }.joined(separator: ", ")
    }
}
