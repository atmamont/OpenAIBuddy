//
//  OpenAIHttpService.swift
//  OpenAIBuddy
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

class OpenAIHttpService: HTTPService {
    private var token: String = {
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return "" }
        guard let token: String = infoDictionary["OPENAI_TOKEN"] as? String else { return "" }
        return token
    }()
    private let url = URL(string: "https://api.openai.com/v1")!
    
    init() {
        super.init(baseURL: url, token: token)
    }
}

extension OpenAIHttpService: FeedService {
    func send(_ message: ChatMessage, context: [ChatMessage], completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        let body = OpenAICompletionRequest(messages: context)

        self.executeRequest(
            path: "chat/completions",
            method: "POST",
            body: body)
        { (result: Result<OpenAICompletionResponse, Error>) in
            
            switch result {
            case .success(let response):
                guard let message = response.choices.first?.message else { return }
                completion(.success(message.chatMessage()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
