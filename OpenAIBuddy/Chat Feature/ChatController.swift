//
//  ChatController.swift
//  OpenAIBuddy
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

struct ChatMessage {
    let role: ChatUserRole
    let content: String
}

enum ChatUserRole: String {
    case user
    case assistant
    case system
}

protocol FeedService {
    func send(_ message: ChatMessage,
              context: [ChatMessage],
              completion: @escaping (Result<ChatMessage, Error>) -> Void)
}

class ChatController: ObservableObject {
    private let service: FeedService
    private static let conversationContextMessageCount = 5
    
    @Published var messages: [ChatMessage] = []
    @Published var error: Error?
    
    init(service: FeedService = OpenAIHttpService()) {
        self.service = service
    }
}

// MARK: - Requests

extension ChatController {
    func send(_ inputText: String) {
        let message = ChatMessage(role: .user, content: inputText)
        messages.append(message)

        service.send(message, context: prepareMessages()) { [weak self] result in
            switch result {
            case .success(let message):
                self?.messages.append(message)
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    private func prepareMessages() -> [ChatMessage] {
        messages.suffix(ChatController.conversationContextMessageCount)
    }
}

