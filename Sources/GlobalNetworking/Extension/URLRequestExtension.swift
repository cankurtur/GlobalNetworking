//
//  URLRequestExtension.swift
//  TestNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

extension URLRequest {
    /// Generates a cURL command representation of the `URLRequest`.
    ///
    /// - Includes:
    ///   - HTTP method (`-X <METHOD>`)
    ///   - Headers (`-H "Header: Value"`)
    ///   - Body (`-d '<JSON body>'`)
    ///   - URL (`<request URL>`)
    ///
    /// - Returns: A `String` containing the equivalent `cURL` command.
    var curlString: String {
            var result = "curl -k "

            if let method = httpMethod {
                result += "-X \(method) \\\n"
            }

            if let headers = allHTTPHeaderFields {
                for (header, value) in headers {
                    result += "-H \"\(header): \(value)\" \\\n"
                }
            }

            if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
                result += "-d '\(string)' \\\n"
            }

            if let url = url {
                result += url.absoluteString
            }

            return result
    }
}
