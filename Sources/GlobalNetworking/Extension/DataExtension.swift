//
//  DataExtension.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//


import Foundation

extension Data {
    /// Converts `Data` containing JSON into a pretty-printed JSON string.
    /// This computed property attempts to deserialize the `Data` into a JSON object.
    /// - Returns: A formatted JSON string (`NSString`) if successful, otherwise `nil`.
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
