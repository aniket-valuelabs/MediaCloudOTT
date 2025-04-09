//
//  Item.swift
//  OTTPoc
//
//  Created by Aniket Kumar on 07/04/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
