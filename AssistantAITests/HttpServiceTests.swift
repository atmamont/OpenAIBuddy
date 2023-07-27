//
//  HttpServiceTests.swift
//  AssistantAITests
//
//  Created by Andrei on 27/07/2023.
//

import XCTest
@testable import AssistantAI

final class HttpServiceTests: XCTestCase {
    private let baseUrl = URL(string: "baseUrl")!
    private let token = "token"
    private let path = "path"
    private let method = "POST"
    
    private var urlSession: URLSession!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession.init(configuration: configuration)
    }
    
    func test_httpService_executeSetsHeaders() {
        let data = "".data(using: .utf8)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: self.baseUrl,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(self.token)")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            return (response, data)
        }
        
        let sut = HTTPService(baseURL: baseUrl, token: token)
        sut.executeRequest(path: "path", method: method, body: MockBody()) { (result: Result<MockResponse, Error>) in
        }
    }
}

private struct MockBody: Codable {}
private struct MockResponse: Codable {}
