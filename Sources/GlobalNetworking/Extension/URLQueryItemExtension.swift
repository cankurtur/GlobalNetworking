//
//  URLQueryItemExtension.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

/// Converts a dictionary of key-value pairs to an array of URLQueryItem objects.
extension URLQueryItem {
    static func queryItems(dictionary: [String: Any]) -> [URLQueryItem] {
        dictionary.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
    }
}
