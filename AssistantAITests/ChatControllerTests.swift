//
//  ChatControllerTests.swift
//  AssistantAITests
//
//  Created by Andrei on 25/05/2023.
//

import XCTest
@testable import AssistantAI

final class ChatControllerTests: XCTestCase {
    
    func test_chatController_sendsRequest() {
        let mockHttpService = HTTPServiceMock(baseURL: URL(string: "baseUrl")!, token: "token")
        let sut = ChatController(httpService: mockHttpService)
        sut.send("Test message")
        
        XCTAssertEqual(mockHttpService.executeRequestCallCount, 1)
    }
    
    func test_chatController_appendsUserMessage() {
        let mockHttpService = HTTPServiceMock(baseURL: URL(string: "baseUrl")!, token: "token")
        mockHttpService.defaultResponse = ChatCompletionResponse(choices: []) // no need to handle server response
        let userInputText = "Test message"
        let sut = ChatController(httpService: mockHttpService)
        sut.send(userInputText)
        
        XCTAssertEqual(sut.messages.count, 1)
        let assistantMessages = sut.messages.filter { $0.role == .user }
        XCTAssertEqual(assistantMessages.last?.content, userInputText)
    }
    
    func test_chatController_appendsMessageOnSuccess() {
        let mockHttpService = HTTPServiceMock(baseURL: URL(string: "baseUrl")!, token: "token")
        let sut = ChatController(httpService: mockHttpService)
        sut.send("Test message")
        
        XCTAssertEqual(sut.messages.count, 2)
        let assistantMessages = sut.messages.filter { $0.role == .assistant }
        XCTAssertEqual(assistantMessages.last?.content, mockHttpService.defaultResponseText)
    }
    
    func test_chatController_publishesErrorOnFailure() {
        let mockHttpService = HTTPServiceMock(baseURL: URL(string: "baseUrl")!, token: "token")
        mockHttpService.defaultError = NSError(domain: "any", code: 0)
        
        let sut = ChatController(httpService: mockHttpService)
        sut.send("Test message")
        
        XCTAssertNotNil(sut.error, "Error should be not nil")
    }
    
    func test_chatController_preservesMessagesContextOnSend() {
        let mockHttpService = HTTPServiceMock(baseURL: URL(string: "baseUrl")!, token: "token")

        let sut = ChatController(httpService: mockHttpService)
        sut.messages = [
            ChatMessage(role: .user, content: "First message"),
            ChatMessage(role: .assistant, content: "First reply")
        ]
        
        sut.send("Second message")
        
        let body: ChatCompletionRequest = try! XCTUnwrap(mockHttpService.recordedBody) as! ChatCompletionRequest
        XCTAssertEqual(body.messages.count, 3)
    }
}

class HTTPServiceMock: HTTPService {
    var executeRequestCallCount = 0
    
    let defaultResponseText = "Hi how can I help you?"
    lazy var defaultResponse = ChatCompletionResponse(
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
