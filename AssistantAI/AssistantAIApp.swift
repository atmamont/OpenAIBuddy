//
//  AssistantAIApp.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import SwiftUI

@main
struct AssistantAIApp: App {
    @StateObject var controller = ChatController()
    var body: some Scene {
        WindowGroup {
            ContentView(controller: controller)
        }
    }
}
