//
//  MockURLSession.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

import Foundation
import Combine
import GlobalNetworking

class MockURLSession: URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return URLSession.DataTaskPublisher(request: request, session: session)
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return try await session.data(for: request)
    }
}

