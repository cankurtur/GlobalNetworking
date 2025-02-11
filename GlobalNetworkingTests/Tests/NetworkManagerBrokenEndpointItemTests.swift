//
//  NetworkManagerBrokenEndpointItemTests.swift
//  GlobalNetworkingTests
//
//  Created by Can Kurtur on 11.02.2025.
//

import XCTest
import Combine
@testable import GlobalNetworking

final class NetworkManagerBrokenEndpointItemTests: XCTestCase {
    
    var networkManager: NetworkManager<MockClientBrokenEndpointItem>!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager<MockClientBrokenEndpointItem>(
            session: MockURLSession(),
            clientErrorType: MockClientError.self
        )
        cancellables = []
        MockURLProtocol.resetMockData()
    }
    
    override func tearDown() {
        super.tearDown()
        networkManager = nil
        cancellables = nil
        MockURLProtocol.resetMockData()
    }
    
    func test_request_with_combine_bad_request_error() throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let expectedError: APIClientError = .badRequest
        let shoulReceiveErrorExpectation = expectation(description: "Error should receive.")
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: nil)
        
        // When & Then
        networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertEqual(error.message, expectedError.message)
                    XCTAssertEqual(error.debugMessage, expectedError.debugMessage)
                    XCTAssertEqual(error.statusCode, expectedError.statusCode)
                    shoulReceiveErrorExpectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [shoulReceiveErrorExpectation], timeout: 1)
    }
    
    func test_request_with_async_await_bad_request_error() async throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let expectedError: APIClientError = .badRequest
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: nil)
        
        // When
        do {
            let _ = try await networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
        } catch let error as APIClientError {
            // Then
            XCTAssertEqual(error.message, expectedError.message)
            XCTAssertEqual(error.debugMessage, expectedError.debugMessage)
            XCTAssertEqual(error.statusCode, expectedError.statusCode)
        }
    }
}
