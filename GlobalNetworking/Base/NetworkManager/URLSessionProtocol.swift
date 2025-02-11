//
//  URLSessionProtocol.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

/// Conform this protocol to mock URLSession.
public protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol{}
