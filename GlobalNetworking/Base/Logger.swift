//
//  Logger.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

/// Consumer needs to implement concrete type of `NetworkLoggerProtocol`.
public protocol NetworkLoggerProtocol {
    func logCurlString(_ urlRequest: URLRequest?)
    func logRequest(_ endpoint: Endpoint)
    func logResponse(_ responseLogging: ResponseLogging)
}

/// Response logging type.
public enum ResponseLogging {
    case success(data: Data, endpoint: Endpoint)
    case failure(reason: String, endpoint: Endpoint, data: Data? = nil)
}
