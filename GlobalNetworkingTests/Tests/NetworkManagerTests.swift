//
//  NetworkManagerTests.swift
//  GlobalNetworkingTests
//
//  Created by Can Kurtur on 11.02.2025.
//

import XCTest
import Combine
@testable import GlobalNetworking

final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager<MockClientEndpointItem>!
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager<MockClientEndpointItem>(
            session: MockURLSession(),
            clientErrorType: MockClientError.self
        )
    }
    
    override func tearDown() {
        super.tearDown()
        networkManager = nil
    }
    
    func test_request_with_combine_success() throws {
        // Given
        let expectedRootResponse = MockClientRootResponse(
            nextPath: "nextPath"
        )
        
        let data = try XCTUnwrap(JSONEncoder().encode(expectedRootResponse))
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { result in
            let response = HTTPURLResponse(
                url: URL(string: "http://localhost:8000")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        // When
        _ = networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("Unexpected Fail: \(error)")
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.nextPath, expectedRootResponse.nextPath)
            })
    }
    
    func test_request_with_async_await_success() async throws {
        // Given
        let expectedRootResponse = MockClientRootResponse(
            nextPath: "nextPath"
        )
        
        let data = try XCTUnwrap(JSONEncoder().encode(expectedRootResponse))
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { result in
            let response = HTTPURLResponse(
                url: URL(string: "http://localhost:8000")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        // When
        let response = try await networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
        
        // Then
        XCTAssertEqual(response.nextPath, expectedRootResponse.nextPath)
    }
    
    func test_request_with_combine_connection_failure() async throws {
        // Given
        let expectedError = APIClientError.networkError
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        
        MockURLProtocol.connectionFailed = true
        
        // When
        _ = networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertEqual(error.message, expectedError.message)
                    XCTAssertEqual(error.statusCode, expectedError.statusCode)
                }
            }, receiveValue: { _ in })
    }
    
    func test_request_with_async_await_connection_failure() async throws {
        // Given
        let expectedError = APIClientError.networkError
        
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        
        MockURLProtocol.connectionFailed = true
        
        // When
        do {
            let _ = try await networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
        } catch let error as APIClientError {
            // Then
            XCTAssertEqual(error.message, expectedError.message)
            XCTAssertEqual(error.statusCode, expectedError.statusCode)
        }
        
    }
}














