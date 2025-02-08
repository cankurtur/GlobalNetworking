//
//  Endpoint.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

/// A protocol that defines the basic structure and functionality for API endpoints.
public protocol Endpoint: CustomStringConvertible {
    var baseUrl: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    var url: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var defaultHeaders: HTTPHeaders { get }
}

public extension Endpoint {
    /// A description of the endpoint that includes method, URL, headers, and parameters for debugging.
    var description: String {
        var descriptionString = ""
        descriptionString.append(contentsOf: "\nURL: [\(method.rawValue)] \(url)")
        descriptionString.append(contentsOf: "\nHEADERS: \(headers ?? HTTPHeaders())")
        descriptionString.append(contentsOf: "\nPARAMETERS: \(String(describing: params ?? [:]))")
        return descriptionString
    }
    
    /// Defines the encoding used for the parameters depending on the HTTP method (URL or JSON).
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return .url
        default:
            return .json
        }
    }
    
    /// Default headers for the request (Accept, Cache-Control, Content-Type).
    var defaultHeaders: HTTPHeaders {
        let acceptHeader = HTTPHeader(name: "Accept", value: "application/json")
        let cacheHeader = HTTPHeader(name: "Cache-Control", value: "no-cache")
        let contentTypeHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        
        return HTTPHeaders(
            headers: [acceptHeader, cacheHeader, contentTypeHeader]
        )
    }
}
