//
//  ChatController.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

class ChatController: ObservableObject {
    private let httpService = OpenAIHttpService()
    
    @Published var response: String = ""
    
    func request(_ text: String) {
        let message = ChatMessage(role: .user, content: text)
        let body = ChatCompletionRequest(messages: [message])

        httpService.executeRequest(
            path: "chat/completions",
            method: "POST",
            body: body)
        { [weak self] (result: Result<CompletionResponse, Error>) in
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    self?.updateResponse(response.choices.first?.message.content)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateResponse(_ response: String?) {
        self.response = response ?? ""
    }
    
    
}
