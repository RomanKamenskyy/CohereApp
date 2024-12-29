//
//  ChatMessage.swift
//  CohereApp
//
//  Created by roman on 12/29/24.
//

import Foundation
import SwiftData

@Model
class ChatMessage {
    @Attribute(.unique) var id: UUID
    var role: String 
    var content: String
    var timestamp: Date

    init(id: UUID = UUID(), role: String, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}
