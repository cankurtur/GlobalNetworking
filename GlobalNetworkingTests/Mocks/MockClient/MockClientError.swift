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
}
