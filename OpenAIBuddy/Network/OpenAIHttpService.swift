//
//  OpenAIHttpService.swift
//  OpenAIBuddy
//
//  Created by Andrei on 25/05/2023.
//

import Foundation

class OpenAIHttpService: HTTPService {
    private var token: String = {
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return "" }
        guard let token: String = infoDictionary["OPENAI_TOKEN"] as? String else { return "" }
        return token
    }()
    private let url = URL(string: "https://api.openai.com/v1")!
    
    init() {
        super.init(baseURL: url, token: token)
    }
    
    
}
