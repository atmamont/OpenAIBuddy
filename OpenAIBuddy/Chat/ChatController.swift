//
//  ChatController.swift
//  OpenAIBuddy
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

protocol FeedService {
    func send(_ message: ChatMessage,
              context: [ChatMessage],
              completion: @escaping (Result<ChatMessage, Error>) -> Void)
}

class ChatController: ObservableObject {
    private let service: FeedService
    
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
        messages.suffix(10)
    }
    
    private func handle(error: Error) {
        self.error = error
    }
}

extension OpenAIHttpService: FeedService {
    func send(_ message: ChatMessage, context: [ChatMessage], completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        let body = ChatCompletionRequest(messages: context)

        self.executeRequest(
            path: "chat/completions",
            method: "POST",
            body: body)
        { (result: Result<ChatCompletionResponse, Error>) in
            switch result {
            case .success(let response):
                guard let message = response.choices.first?.message else { return }
                completion(.success(message))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
