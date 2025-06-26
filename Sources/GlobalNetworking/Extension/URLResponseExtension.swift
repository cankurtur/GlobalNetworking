//
//  URLResponseExtension.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

/// Extracts the HTTP status code from a `URLResponse` if it is an `HTTPURLResponse`.
extension URLResponse {
    var code: Int {
        let response = self as! HTTPURLResponse
        return response.statusCode
    }
}

/**
 According to Apple's documentation, HTTP requests are guaranteed to always return HTTPURLResponse instances. Therefore, force casting is not problematic in this case.
 
 Overview
 The related HTTPURLResponse class is a commonly used subclass of URLResponse whose objects represent a response to an HTTP URL load request and store additional protocol-specific information such as the response headers. Whenever you make an HTTP request, the URLResponse object you get back is actually an instance of the HTTPURLResponse class.
 https://developer.apple.com/documentation/foundation/urlresponse#overview
 */
