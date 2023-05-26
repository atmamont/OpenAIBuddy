//
//  ChatMessageView.swift
//  AssistantAI
//
//  Created by Andrei on 26/05/2023.
//

import SwiftUI

enum MessageStyle {
    case user
    case assistant
    case system
}

extension UserRole {
    var messageStyle: MessageStyle {
        switch self {
        case .assistant: return .assistant
        case .system: return .system
        case .user: return .user
        }
    }
}

struct ChatMessageView: View {
    let message: String
    let style: MessageStyle

    var body: some View {
        VStack {
            switch style {
            case .user:
                UserMessageView(message: message)
            case .assistant:
                AssistantMessageView(message: message)
            case .system:
                SystemMessageView(message: message)
            }
        }
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatMessageView(message: "Hello!", style: .user)
                .padding()
            
            ChatMessageView(message: "Hi there!", style: .assistant)
                .padding()
            
            ChatMessageView(message: "Welcome to the chat.", style: .system)
                .padding()
        }
    }
}


// MARK: - Specific role views

struct UserMessageView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
    }
}

struct AssistantMessageView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
    }
}

struct SystemMessageView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding()
            .foregroundColor(.gray)
            .italic()
    }
}
