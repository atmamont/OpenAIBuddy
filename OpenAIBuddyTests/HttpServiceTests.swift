//
//  HttpServiceTests.swift
//  OpenAIBuddyTests
//
//  Created by Andrei on 27/07/2023.
//

import XCTest
@testable import OpenAIBuddy

final class HttpServiceTests: XCTestCase {
    private let baseUrl = URL(string: "http://baseUrl")!
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
        
        let sut = BaseHTTPService(baseURL: baseUrl, token: token, urlSession: urlSession)
        sut.executeRequest(path: "path", method: method, body: MockBody()) { (result: Result<MockResponse, Error>) in
        }
    }
    
    func test_httpService_failure() {
        let data = "".data(using: .utf8)
        let body = MockBody()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: self.baseUrl,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil)!
            
            return (response, data)
        }

        let exp = expectation(description: "Network")
        
        let sut = BaseHTTPService(baseURL: baseUrl, token: token, urlSession: urlSession)
        sut.executeRequest(path: "path", method: method, body: body) { (result: Result<MockResponse, Error>) in
            
            switch result {
            case .success:
                XCTFail("Should be a failure")
            case .failure(let error):
                XCTAssertEqual((error as NSError).code, 404)
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }
}

private struct MockBody: Codable {}
private struct MockResponse: Codable {}
