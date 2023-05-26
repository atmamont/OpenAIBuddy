//
//  CompletionResponse.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

struct CompletionResponse: Codable {
    let choices: [CompletionChoice]
}

struct CompletionChoice: Codable {
    let message: ChatMessage
}
