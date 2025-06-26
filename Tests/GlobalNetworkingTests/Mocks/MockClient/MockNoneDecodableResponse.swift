//
//  MockNoneDecodableResponse.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

import Foundation

struct MockNoneDecodableResponse: Codable {
    let nextPath: Int?
    
    enum CodingKeys: String, CodingKey {
        case nextPath = "next_path"
    }
}
