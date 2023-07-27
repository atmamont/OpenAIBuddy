//
//  AssistantAITests.swift
//  AssistantAITests
//
//  Created by Andrei on 25/05/2023.
//

import XCTest
@testable import AssistantAI

final class AssistantAITests: XCTestCase {
    
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
}

class HTTPServiceMock: HTTPService {
    var executeRequestCallCount = 0
    lazy var defaultResponse = ChatCompletionResponse(
        choices: [.init(message: .init(role: .assistant,
                                       content: defaultResponseText)),
                  .init(message: .init(role: .assistant, content: "Another message"))]
    )
    let defaultResponseText = "Hi how can I help you?"
    
    override func executeRequest<RequestBody, Response>(path: String, method: String, body: RequestBody? = nil, completion: @escaping (Result<Response, Error>) -> Void) where RequestBody : Encodable, Response : Decodable {
        
        let response = defaultResponse
        
        executeRequestCallCount += 1
        completion(.success(response as! Response))
    }
}
