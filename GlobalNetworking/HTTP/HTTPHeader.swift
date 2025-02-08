//
//  HTTPHeader.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation

public struct HTTPHeader {
    /// Name of the header.
    public let name: String
    
    /// Value of the header
    public let value: String
    
    /// Creates an instance from the given `name` and `value`.
    ///
    ///  - Parameters:
    ///   - name: The name of the header.
    ///   - value: The value of the header.
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
