//
//  NetworkLogger.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation
import os.log

/// A default logger class that helps track network requests and responses.
///
/// `NetworkLogger` logs network activity, including cURL representations of requests,
/// outgoing requests, and incoming responses, to aid in debugging.
///
/// - Implements: `NetworkLoggerProtocol`
/// - Uses: Apple's `Logger` API for structured logging.

final public class NetworkLogger: NetworkLoggerProtocol {
    
    private let logger: Logger
    
    public init() {
        let bundleIdentifier = Bundle(for: NetworkLogger.self).bundleIdentifier ?? "cankurtur.GlobalNetworking"
        self.logger = Logger(subsystem: bundleIdentifier, category: "Network")
    }
    
    public func logCurlString(_ urlRequest: URLRequest?) {
        guard let curlString = urlRequest?.curlString else { return }
        
        let divider = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        logger.info("🔄 \(divider) cURL \(divider)\n\(curlString)")
    }
    
    public func logRequest(_ endpoint: any Endpoint) {
        let divider = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        logger.info("📡 \(divider) REQUEST \(divider)\nEndpoint: \(endpoint.description )")
    }
    
    public func logResponse(_ responseLogging: ResponseLogging) {
        let divider = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        switch responseLogging {
        case .success(let data, let endpoint):
            logger.info("🟢 \(divider) SUCCESS RESPONSE \(divider)\nURL: \(endpoint.url)\nDATA: \(data.prettyPrintedJSONString ?? "EMPTY RESPONSE")")
        case .failure(let reason, let endpoint, let data):
            logger.info("🔴 \(divider) FAILURE RESPONSE \(divider)\nURL: \(endpoint.url)\nREASON: \(reason)\nDATA: \(data?.prettyPrintedJSONString ?? "EMPTY RESPONSE")")
        }
    }
}
