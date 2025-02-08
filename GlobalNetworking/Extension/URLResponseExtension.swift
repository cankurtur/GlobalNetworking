//
//  URLResponseExtension.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

/// Extracts the HTTP status code from a `URLResponse` if it is an `HTTPURLResponse`.
extension URLResponse {
    var code: Int? {
        guard let response = self as? HTTPURLResponse else {
            return nil
        }
        
        return response.statusCode
    }
}
