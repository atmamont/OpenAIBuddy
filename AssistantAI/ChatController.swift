//
//  ChatController.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

class ChatController: ObservableObject {
    @Published var response: String = ""
    
    func request(_ text: String) {
        // assume we make request
        response = "Fake response \(arc4random())"
    }
}
