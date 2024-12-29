//
//  ChatViewModel.swift
//  CohereApp
//
//  Created by roman on 12/29/24.
//

import Foundation
import SwiftData

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputMessage: String = ""

    private var context: ModelContext?

    private let chatService = ChatService()

    func setContext(_ context: ModelContext) {
        self.context = context
    }

    func sendMessage() {
        guard let context = context else {
            print("Context is not set")
            return
        }

        let userMessage = inputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userMessage.isEmpty else { return }

        saveMessage(context: context, role: "user", content: userMessage)

        inputMessage = ""

        chatService.sendMessage(prompt: userMessage) { [weak self] response in
            DispatchQueue.main.async {
                if let response = response {
                    // Сохранить ответ от AI
                    self?.saveMessage(context: context, role: "assistant", content: response)
                } else {
                    // Обрабатываем ошибку
                    self?.saveMessage(context: context, role: "assistant", content: "Ошибка при получении ответа.")
                }
            }
        }
    }

    func loadMessages() {
        guard let context = context else {
            print("Context is not set")
            return
        }

        let fetchRequest = FetchDescriptor<ChatMessage>(
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        do {
            messages = try context.fetch(fetchRequest)
        } catch {
            print("Ошибка загрузки сообщений: \(error)")
        }
    }

    private func saveMessage(context: ModelContext, role: String, content: String) {
        let newMessage = ChatMessage(role: role, content: content)
        do {
            context.insert(newMessage)
            try context.save()
            messages.append(newMessage)
        } catch {
            print("Ошибка сохранения сообщения: \(error)")
        }
    }
}
