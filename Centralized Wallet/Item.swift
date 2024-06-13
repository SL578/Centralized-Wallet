//
//  Item.swift
//  Centralized Wallet
//
//  Created by Stephen Lin on 6/13/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var placeholder = 3
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
