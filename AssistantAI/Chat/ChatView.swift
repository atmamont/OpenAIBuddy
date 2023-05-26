//
//  ContentView.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var controller: ChatController
    
    @State var input: String = ""
    var onSendTap: (() -> Void)?
    
    var body: some View {
        VStack {
            List(controller.messages, id: \.content) { item in
                ChatMessageView(message: item.content, style: item.role.messageStyle)
            }
            HStack {
                TextField("You:", text: $input)
                Button("Send") {
                    controller.send(input)
                    input = ""
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(controller: ChatController())
    }
}
