//
//  Errors.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

/// Generic error type for networking layer. You can define your own error type by conforming to this protocol.
public protocol APIError: Codable, AnyObject {
    var error: String { get }
    var statusCode: Int? { get set }
}

/// Defines various error types that can occur in APIClient.
public enum APIClientError: Error {
    case handledError(error: APIError)
    case networkError
    case decodingError(error: DecodingError?)
    case timeout
    case badRequest
    
    /// Human readable error message.
    public var message: String {
        switch self {
        case .handledError(let error):
            return error.error
        case .networkError:
            return "Could not connect to the server"
        case .decodingError:
            return "Failed to decode response"
        case .timeout:
            return "Request timed out"
        case .badRequest:
            return "Bad request"
        }
    }
    
    /// Debug message, providing more detailed error information.
    public var debugMessage: String {
        switch self {
        case .handledError(let error):
            return error.error
        case .networkError:
            return "Network error"
        case .decodingError(let error):
            guard let decodingError = error else { return "Decoding Error" }
            return "Decoding Error: \(decodingError)"
        case .timeout:
            return "Timeout"
        case .badRequest:
            return "Bad request"
        }
    }
    
    /// Corresponding HTTP status code.
    public var statusCode: Int {
        switch self {
        case .handledError(let error):
            return error.statusCode ?? 0
        case .networkError:
            return NSURLErrorNotConnectedToInternet
        case .decodingError:
            return NSURLErrorCannotDecodeRawData
        case .timeout:
            return NSURLErrorTimedOut
        case .badRequest:
            return 400
        }
    }
}
