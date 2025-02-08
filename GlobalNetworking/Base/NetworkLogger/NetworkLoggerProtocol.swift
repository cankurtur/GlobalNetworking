//
//  NetworkLoggerProtocol.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

/// Consumer needs to implement concrete type of `NetworkLoggerProtocol`.
public protocol NetworkLoggerProtocol {
    /// Logs a cURL string representation of the given `URLRequest`.
    ///
    /// - Parameter urlRequest: The request to be logged in cURL format.
    func logCurlString(_ urlRequest: URLRequest?)
    /// Logs details of an outgoing request.
    ///
    /// - Parameter endpoint: The endpoint being requested.
    func logRequest(_ endpoint: Endpoint)
    /// Logs the details of a received response.
    ///
    /// - Parameter responseLogging: The response to be logged, including success or failure.
    func logResponse(_ responseLogging: ResponseLogging)
}

/// Represents the type of response logging for network requests.
///
/// - Cases:
///   - `success(data:endpoint:)`: Represents a successful response with associated data and endpoint.
///   - `failure(reason:endpoint:data:)`: Represents a failed response, including the failure reason,
///     the endpoint, and optionally the response data for debugging.
///
public enum ResponseLogging {
    /// Represents a successful response with data.
    case success(data: Data, endpoint: Endpoint)
    /// Represents a failed response, including the failure reason and optional response data.
    case failure(reason: String, endpoint: Endpoint, data: Data? = nil)
}
