//
//  OpenAIRequest.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

struct CompletionRequest: Codable {
    let model: String = "gpt-3.5-turbo"
//    let messages: [OpenAIMessage]
    let prompt: String
    let max_tokens = 4000
    let temperature = 0.1
}
