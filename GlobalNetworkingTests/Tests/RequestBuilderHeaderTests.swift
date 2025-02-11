//
//  RequestBuilderHeaderTests.swift
//  GlobalNetworkingTests
//
//  Created by Can Kurtur on 11.02.2025.
//

@testable import GlobalNetworking
import XCTest

final class RequestBuilderHeaderTests: XCTestCase {
    
    func test_init_with_headers() {
        // Given
        let headerItems = [
            HTTPHeader(name: "Content-Type", value: "application/json"),
            HTTPHeader(name: "Authorization", value: "Bearer token123")
        ]
        
        // When
        let headers = HTTPHeaders(headers: headerItems)
        let request = URLRequest(url: URL(string: "https://example.com")!)
        let updatedRequest = headers.embed(into: request)
        
        // Then
        XCTAssertEqual(updatedRequest.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "Authorization"), "Bearer token123")
    }
    
    func test_add_header() {
         // Given
         var headers = HTTPHeaders()
         let header = HTTPHeader(name: "Accept", value: "application/json")
         
         // When
         headers.add(header)
         let request = URLRequest(url: URL(string: "https://example.com")!)
         let updatedRequest = headers.embed(into: request)
         
         // Then
         XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "Accept"), "application/json")
     }
    
    func test_add_multiple_headers() {
         // Given
         var headers = HTTPHeaders()
         
         // When
         headers.add(HTTPHeader(name: "Content-Type", value: "application/json"))
         headers.add(HTTPHeader(name: "Accept", value: "application/json"))
         headers.add(HTTPHeader(name: "Authorization", value: "Bearer token123"))
         
         let request = URLRequest(url: URL(string: "https://example.com")!)
         let updatedRequest = headers.embed(into: request)
         
         // Then
         XCTAssertEqual(updatedRequest.allHTTPHeaderFields?.count, 3)
         XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
         XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "Accept"), "application/json")
         XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "Authorization"), "Bearer token123")
     }
    
    func test_embed_into_existing_request() {
        // Given
        var initialRequest = URLRequest(url: URL(string: "https://example.com")!)
        initialRequest.setValue("existing/value", forHTTPHeaderField: "Existing-Header")
        
        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "New-Header", value: "new-value"))
        
        // When
        let updatedRequest = headers.embed(into: initialRequest)
        
        // Then
        XCTAssertEqual(updatedRequest.allHTTPHeaderFields?.count, 2)
        XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "Existing-Header"), "existing/value")
        XCTAssertEqual(updatedRequest.value(forHTTPHeaderField: "New-Header"), "new-value")
    }
}

