//
//  MockClientRootResponse.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

import Foundation

struct MockClientRootResponse: Codable {
    let nextPath: String?
    
    enum CodingKeys: String, CodingKey {
        case nextPath = "next_path"
    }
}
