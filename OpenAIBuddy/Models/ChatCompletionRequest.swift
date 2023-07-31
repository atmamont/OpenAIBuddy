//
//  ChatCompletionRequest.swift
//  OpenAIBuddy
//
//  Created by Andrei on 26/05/2023.
//

import Foundation

struct ChatMessage: Codable {
    let role: ChatUserRole
    let content: String
}

enum ChatUserRole: String, Codable {
    case user
    case assistant
    case system
}

struct ChatCompletionRequest: Encodable {
    let model = "gpt-3.5-turbo"
    let messages: [ChatMessage]
}
