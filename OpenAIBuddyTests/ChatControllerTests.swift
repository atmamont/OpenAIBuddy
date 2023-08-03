//
//  ChatControllerTests.swift
//  OpenAIBuddyTests
//
//  Created by Andrei on 25/05/2023.
//

import XCTest
@testable import OpenAIBuddy

final class ChatControllerTests: XCTestCase {
    
    var mockFeedService = FeedServiceMock()
    
    override func setUp() {
        mockFeedService.sendCallCount = 0
    }
    
    func test_chatController_sendsRequest() {
        let sut = ChatController(service: mockFeedService)
        sut.send("Test message")
        
        XCTAssertEqual(mockFeedService.sendCallCount, 1)
    }
    
    func test_chatController_appendsUserMessage() {
        let userInputText = "Test message"
        let sut = ChatController(service: mockFeedService)
        sut.send(userInputText)
        
        let userMessages = sut.messages.filter { $0.role == .user }
        XCTAssertEqual(userMessages.count, 1)
        XCTAssertEqual(userMessages.last?.content, userInputText)
    }
    
    func test_chatController_appendsMessageOnSuccess() {
        let sut = ChatController(service: mockFeedService)
        sut.send("Test message")
        
        XCTAssertEqual(sut.messages.count, 2)
        let assistantMessages = sut.messages.filter { $0.role == .assistant }
        XCTAssertEqual(assistantMessages.last?.content, mockFeedService.responseText)
    }
    
    func test_chatController_publishesErrorOnFailure() {
        mockFeedService.error = NSError(domain: "any", code: 0)
        
        let sut = ChatController(service: mockFeedService)
        sut.send("Test message")
        
        XCTAssertNotNil(sut.error, "Error should be not nil")
    }
    
    func test_chatController_preservesMessagesContextOnSend() {
        let sut = ChatController(service: mockFeedService)
        sut.messages = [
            ChatMessage(role: .user, content: "First message"),
            ChatMessage(role: .assistant, content: "First reply")
        ]
        
        sut.send("Second message")
        
        XCTAssertEqual(mockFeedService.savedContext?.count, 3)
    }
}

class HTTPServiceMock: HTTPService {
    var executeRequestCallCount = 0
    
    let defaultResponseText = "Hi how can I help you?"
    lazy var defaultResponse = OpenAICompletionResponse(
        choices: [.init(message: .init(role: .assistant,
                                       content: defaultResponseText)),
                  .init(message: .init(role: .assistant, content: "Another message"))]
    )
    var defaultError: Error?
    var recordedBody: Encodable?
    
    override func executeRequest<RequestBody, Response>(path: String, method: String, body: RequestBody? = nil, completion: @escaping (Result<Response, Error>) -> Void) where RequestBody : Encodable, Response : Decodable {
        
        executeRequestCallCount += 1
        recordedBody = body
        
        if let defaultError {
            completion(.failure(defaultError))
        } else {
            completion(.success(defaultResponse as! Response))
        }
    }
}

class FeedServiceMock: FeedService {
    var defaultCompletion: (((Result<ChatMessage, Error>) -> Void) -> Void)?
    let responseText = "Hi how can I help you?"
    var error: Error?
    var sendCallCount = 0
    
    var savedContext: [ChatMessage]?
    
    func send(_ message: ChatMessage, context: [ChatMessage], completion: @escaping (Result<ChatMessage, Error>) -> Void) {
        sendCallCount += 1
        savedContext = context
        
        if let error {
            completion(.failure(error))
        } else {
            completion(.success(ChatMessage(role: .assistant, content: responseText)))
        }
        
    }
}
