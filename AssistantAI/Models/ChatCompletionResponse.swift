//
//  ChatCompletionResponse.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

struct ChatCompletionResponse: Codable {
    let choices: [ChatCompletionChoice]
}

struct ChatCompletionChoice: Codable {
    let message: ChatMessage
}
