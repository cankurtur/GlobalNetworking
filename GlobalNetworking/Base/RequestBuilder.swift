//
//  RequestBuilder.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

final class RequestBuilder {
    /// Builds `URLRequest` from endpoint.
    /// - Parameters:
    ///   - endpoint: Given endpoint.
    ///   - timeoutInterval: Given timeout.
    /// - Returns: URLRequest.
    static func makeRequest(for endpoint: Endpoint, timeoutInterval: TimeInterval) -> URLRequest? {
        guard let url = prepareURLComponents(for: endpoint)?.url else { return nil }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = prepareBodyDataIfNeeded(for: endpoint)
        request = prepareHeaders(for: endpoint, into: request)
        
        return request
    }
    
    /// Prepares query items if `encoding` type is url.
    /// - Parameter endpoint: Given endpoint.
    /// - Returns: Returns URLComponents object with applied query items.
    private static func prepareURLComponents(for endpoint: Endpoint) -> URLComponents? {
        var component = URLComponents(string: endpoint.url)
        
        if endpoint.encoding == .url, let parameters = endpoint.params {
            let queryItems = URLQueryItem.queryItems(dictionary: parameters)
            component?.queryItems = queryItems
        }
        
        return component
    }
    
    /// Prepares data from given parameters and provide it to request if `encoding` type is json.
    /// - Parameter endpoint: Given endpoint.
    /// - Returns: Data for json body.
    private static func prepareBodyDataIfNeeded(for endpoint: Endpoint) -> Data? {
        guard endpoint.encoding == .json, let parameters = endpoint.params else { return nil }
        
        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
    
    /// Embeds the headers into given url request.
    /// - Parameter request: Given url request.
    /// - Parameter endpoint: Given endpoint.
    /// - Returns: Updated url request.
    private static func prepareHeaders(for endpoint: Endpoint, into request: URLRequest) -> URLRequest {
        guard let headers = endpoint.headers else { return request }
        return headers.embed(into: request)
    }
}

