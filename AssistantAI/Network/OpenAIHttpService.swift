//
//  OpenAIHttpService.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

class OpenAIHttpService: HTTPService {
    private let token = "***REMOVED***"
    private let url = URL(string: "https://api.openai.com/v1")!
    
    init() {
        super.init(baseURL: url, token: token)
    }
}
