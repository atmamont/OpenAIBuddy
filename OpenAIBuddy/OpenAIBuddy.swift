//
//  OpenAIBuddy.swift
//  OpenAIBuddy
//
//  Created by Andrei on 25/05/2023.
//

import SwiftUI

@main
struct OpenAIBuddy: App {
    @StateObject var controller = ChatController()
    var body: some Scene {
        WindowGroup {
            ChatView(controller: controller)
        }
    }
}
