//
//  MockClientErro.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

import GlobalNetworking

class MockClientError: APIError {
    var error: String
    var statusCode: Int?
    
    init(error: String, statusCode: Int? = nil) {
        self.error = error
        self.statusCode = statusCode
    }
}

class MockDecodingError: Codable {
    var message: String
    var statusCode: Int?
    
    init(message: String, statusCode: Int? = nil) {
        self.message = message
        self.statusCode = statusCode
    }
}
