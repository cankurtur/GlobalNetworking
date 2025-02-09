//
//  NetworkManagerProtocol.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation
import Combine

/// A protocol defining the requirements for a network manager that handles API requests using Combine, async/await, and callback-based approaches.
public protocol NetworkManagerProtocol {
    func request<T: Decodable>(endpoint: some Endpoint, responseType: T.Type) -> AnyPublisher<T, APIClientError>
    func request<T: Decodable>(endpoint: some Endpoint, responseType: T.Type) async throws -> T
    func request<T: Decodable>(endpoint: some Endpoint, responseType: T.Type, completion: @escaping NetworkHandler<T>)
}
