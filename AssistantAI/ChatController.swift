//
//  ChatController.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

class ChatController: ObservableObject {
    private let httpService = OpenAIHttpService()
    
    @Published var messages: [ChatMessage] = []
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
        { [weak self] (result: Result<CompletionResponse, Error>) in
            switch result {
            case .success(let response):
                print(response)
                
                guard let message = response.choices.first?.message else { return }
                DispatchQueue.main.async {
                    self?.handleResponseMessage(message)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func handleResponseMessage(_ message: ChatMessage) {
        messages.append(message)
    }
}
