//
//  MockClientEndpointItem.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

import GlobalNetworking

enum MockClientEndpointItem: Endpoint {
    case getRoot
    case getResponseCode(_ path: String)
    
    var path: String {
        switch self {
        case .getRoot:
            return ""
        case .getResponseCode(let path):
            return path
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRoot, .getResponseCode:
            return .get
        }
    }
}

// To test Bad Request error on network manager.
enum MockClientBrokenEndpointItem: Endpoint {
    case getRoot
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseUrl: String {
        return "h t t p://localhost:8000"
    }
}
