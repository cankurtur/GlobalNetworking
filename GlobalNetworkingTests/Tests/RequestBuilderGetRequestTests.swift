//
//  RequestBuilderGetRequestTests.swift
//  GlobalNetworkingTests
//
//  Created by Can Kurtur on 11.02.2025.
//

import XCTest
@testable import GlobalNetworking

final class RequestBuilderGetRequestTests: XCTestCase {
    
    enum MockGetRequestEndointItem: Endpoint {
        case fetchSomething(something: String)
        case fetchSomethingTwo
        
        var path: String {
            switch self {
            case .fetchSomething(let something):
                return "/\(something)"
            case .fetchSomethingTwo:
                return ""
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
    }

    func test_request_with_params_in_path() {
        let request = RequestBuilder.makeRequest(
            for: MockGetRequestEndointItem.fetchSomething(something: "something"),
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.timeoutInterval, 10)
        XCTAssertEqual(request?.url?.absoluteString, "http://localhost:8000/something")
        XCTAssertEqual(request?.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func test_request_with_no_params() {
        let request = RequestBuilder.makeRequest(
            for: MockGetRequestEndointItem.fetchSomethingTwo,
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.timeoutInterval, 10)
        XCTAssertEqual(request?.url?.absoluteString, "http://localhost:8000")
        XCTAssertEqual(request?.httpMethod, HTTPMethod.get.rawValue)
    }
}
