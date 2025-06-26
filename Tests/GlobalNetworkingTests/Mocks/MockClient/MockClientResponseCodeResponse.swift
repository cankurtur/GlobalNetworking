//
//  MockClientResponseCodeResponse.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

struct MockClientResponseCodeResponse: Codable {
    let path: String?
    let responseCode: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case responseCode = "response_code"
    }
}
