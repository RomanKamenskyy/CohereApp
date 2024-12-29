//
//  CohereAppApp.swift
//  CohereApp
//
//  Created by roman on 12/29/24.
//

import SwiftUI
import SwiftData

@main
struct CohereApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView()
                .modelContainer(for: ChatMessage.self)
        }
    }
}
