//
//  HTTPMethod.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    
    /// `QUERY` method.
    public static let query = HTTPMethod(rawValue: "QUERY")
    
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
