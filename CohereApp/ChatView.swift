//
//  ChatView.swift
//  CohereApp
//
//  Created by roman on 12/29/24.
//

import SwiftUI
import SwiftData


struct ChatView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            Text("\(message.role == "user" ? "You" : "AI"): \(message.content)")
                                .frame(maxWidth: .infinity, alignment: message.role == "user" ? .trailing : .leading)
                                .padding()
                                .background(message.role == "user" ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                    }
                    .onChange(of: viewModel.messages.count) { _ in

                        withAnimation {
                            scrollView.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("Enter message...", text: $viewModel.inputMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: viewModel.sendMessage) {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.setContext(context)
            viewModel.loadMessages()
        }
    }
}
