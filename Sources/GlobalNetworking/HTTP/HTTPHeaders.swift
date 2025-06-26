//
//  HTTPHeaders.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

public struct HTTPHeaders {
    private var headers: [String: String] = [:]
    
    /// Creates an empty instance.
    public init() { }
    
    /// Creates an instance from an array of `HTTPHeader`s.
    public init(headers: [HTTPHeader]) {
        self.headers = Dictionary(uniqueKeysWithValues: headers.map { ($0.name, $0.value) })
    }
    
    /// Adds a specific header into headers.
    ///  - Parameter header: Given header.
    public mutating func add(_ header: HTTPHeader) {
        headers[header.name] = header.value
    }
    
    /// Embed the headers into given url request.
    /// - Parameter request: Given url request.
    /// - Returns: Updated url request.
    public func embed(into request: URLRequest) -> URLRequest {
        var request = request
        
        headers.forEach { name, value in
            request.addValue(value, forHTTPHeaderField: name)
        }
        
        return request
    }
}
