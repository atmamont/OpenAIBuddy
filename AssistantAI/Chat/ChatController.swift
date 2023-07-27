//
//  ChatController.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

class ChatController: ObservableObject {
    private let httpService: HTTPService
    
    @Published var messages: [ChatMessage] = []
    
    init(httpService: HTTPService = OpenAIHttpService()) {
        self.httpService = httpService
    }
}

// MARK: - Requests

extension ChatController {
    func send(_ inputText: String) {
        let message = ChatMessage(role: .user, content: inputText)
        self.messages.append(message)
        
        send(message)
    }
    
    private func send(_ message: ChatMessage) {
        let body = ChatCompletionRequest(messages: [message])

        httpService.executeRequest(
            path: "chat/completions",
            method: "POST",
            body: body)
        { [weak self] (result: Result<ChatCompletionResponse, Error>) in
            switch result {
            case .success(let response):
                print(response)
                
                guard let message = response.choices.first?.message else { return }
                self?.handleResponseMessage(message)
                
            case .failure(let error):
                self?.handle(error: error)
            }
        }
    }
    
    private func handleResponseMessage(_ message: ChatMessage) {
        messages.append(message)
    }
    
    private func handle(error: Error) {
        print(error)
    }
}
