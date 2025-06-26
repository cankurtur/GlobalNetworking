//
//  MockClientEndpoint.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

import Foundation
@testable import GlobalNetworking

extension Endpoint {
    var baseUrl: String {
        return "http://localhost:8000"
    }
    
    var params: [String: Any]? {
        return nil
    }
    
    var url: String {
        return "\(baseUrl)\(path)"
    }
    
    var headers: HTTPHeaders? {
        var headers = defaultHeaders
        let authHeader = HTTPHeader(name: "Authorization", value: "Test token")
        headers.add(authHeader)
        return headers
    }
}
