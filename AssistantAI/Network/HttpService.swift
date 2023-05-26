//
//  HttpService.swift
//  AssistantAI
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

import Foundation

class HTTPService {
    private let baseURL: URL
    private let token: String

    init(baseURL: URL, token: String) {
        self.baseURL = baseURL
        self.token = token
    }

    private func createRequest(path: String, method: String) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    func executeRequest<RequestBody: Encodable, Response: Decodable>(path: String, method: String, body: RequestBody? = nil, completion: @escaping (Result<Response, Error>) -> Void) {
        var request = createRequest(path: path, method: method)
        
        print("Headers: \(request.allHTTPHeaderFields)")

        if let requestBody = body {
            do {
                print("Body: \(body)")
                let encodedBody = try JSONEncoder().encode(requestBody)
                let encodedString = String(data: encodedBody, encoding: .utf8)
                print("Encoded body: \(encodedString)")
                request.httpBody = encodedBody
            } catch {
                completion(.failure(error))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let unknownError = NSError(domain: "HTTPService", code: 0, userInfo: nil)
                completion(.failure(unknownError))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let statusCodeError = NSError(domain: "HTTPService", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(statusCodeError))
                return
            }

            guard let responseData = data else {
                let emptyResponseError = NSError(domain: "HTTPService", code: 0, userInfo: nil)
                completion(.failure(emptyResponseError))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(Response.self, from: responseData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
