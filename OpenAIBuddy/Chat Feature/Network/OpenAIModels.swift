//
//  OpenAIModels.swift
//  OpenAIBuddy
//
//  Created by Andrei on 03/08/2023.
//

import Foundation

struct OpenAICompletionRequest: Encodable {
    let model = "gpt-3.5-turbo"
    let messages: [OpenAIMessage]
    
    init(messages: [ChatMessage]) {
        self.messages = messages
            .map { .init(role: .init($0.role), content: $0.content)}
    }
}

struct OpenAICompletionResponse: Codable {
    let choices: [OpenAICompletionChoice]
}

struct OpenAICompletionChoice: Codable {
    let message: OpenAIMessage
}

struct OpenAIMessage: Codable {
    let role: OpenAIUserRole
    let content: String
    
    func chatMessage() -> ChatMessage {
        ChatMessage(role: role.userRole(),
                    content: content)
    }
}

enum OpenAIUserRole: String, Codable {
    case user
    case assistant
    case system
    
    init(_ role: ChatUserRole) {
        switch role {
        case .assistant:    self = .assistant
        case .system:       self = .system
        case .user:         self = .user
        }
    }
    
    func userRole() -> ChatUserRole {
        switch self {
        case .assistant:    return .assistant
        case .system:       return .system
        case .user:         return .user
        }
    }
}
