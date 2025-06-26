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
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager<MockClientEndpointItem>(
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
    
    func test_request_with_combine_success() throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 200
        let expectedRootResponse = MockClientRootResponse(nextPath: "nextPath")
        let shoulReceiveResponseExpectation = expectation(description: "Response should receive.")

        let data = try XCTUnwrap(JSONEncoder().encode(expectedRootResponse))
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)

        // When & Then
        networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("Unexpected Fail: \(error)")
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.nextPath, expectedRootResponse.nextPath)
                shoulReceiveResponseExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [shoulReceiveResponseExpectation], timeout: 1)
    }
    
    func test_request_with_async_await_success() async throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 200
        let expectedRootResponse = MockClientRootResponse(nextPath: "nextPath")

        let data = try XCTUnwrap(JSONEncoder().encode(expectedRootResponse))
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)

        // When
        let response = try await networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
        
        // Then
        XCTAssertEqual(response.nextPath, expectedRootResponse.nextPath)
    }
    
    func test_request_with_combine_success_empty_response() throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 200
        let expectedEmptyResponse = EmptyResponse()
        let shoulReceiveResponseExpectation = expectation(description: "Response should receive.")

        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: nil)

        // When & Then
        networkManager.request(endpoint: .getRoot, responseType: EmptyResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("Unexpected Fail: \(error)")
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.asDictionary?.count, expectedEmptyResponse.asDictionary?.count)
                shoulReceiveResponseExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [shoulReceiveResponseExpectation], timeout: 1)
    }
    
    func test_request_with_async_await_success_empty_response() async throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 200
        let expectedEmptyResponse = EmptyResponse()
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: nil)

        // When
        let response = try await networkManager.request(endpoint: .getRoot, responseType: EmptyResponse.self)
        
        // Then
        XCTAssertEqual(response.asDictionary?.count, expectedEmptyResponse.asDictionary?.count)
    }
    
    func test_request_with_combine_connection_failure() throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let expectedError = APIClientError.networkError
        let shoulReceiveErrorExpectation = expectation(description: "Error should receive.")

        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: nil)
        MockURLProtocol.connectionFailed = true
        
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
    
    func test_request_with_async_await_connection_failure() async throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let expectedError = APIClientError.networkError

        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: nil)
        MockURLProtocol.connectionFailed = true
        
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
    
    func test_request_with_combine_handled_error_failure() throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let handledError = MockClientError(error: "Handled Error")
        let expectedAPIClientError = APIClientError.handledError(error: handledError)
        let shoulReceiveErrorExpectation = expectation(description: "Error should receive.")

        let data = try XCTUnwrap(JSONEncoder().encode(handledError))
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)
        
        // When & Then
        networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertEqual(error.message, expectedAPIClientError.message)
                    XCTAssertEqual(error.debugMessage, expectedAPIClientError.debugMessage)
                    XCTAssertEqual(error.statusCode, expectedAPIClientError.statusCode)
                    shoulReceiveErrorExpectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        wait(for: [shoulReceiveErrorExpectation], timeout: 1)
    }
    
    func test_request_with_async_await_handled_error_failure() async throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let handledError = MockClientError(error: "Handled Error")
        let expectedAPIClientError = APIClientError.handledError(error: handledError)

        let data = try XCTUnwrap(JSONEncoder().encode(handledError))
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)

        // When
        do {
            let _ = try await networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
        } catch let error as APIClientError {
            // Then
            XCTAssertEqual(error.message, expectedAPIClientError.message)
            XCTAssertEqual(error.debugMessage, expectedAPIClientError.debugMessage)
            XCTAssertEqual(error.statusCode, expectedAPIClientError.statusCode)
        }
    }
    
    func test_request_with_combine_failure_decoding_error() throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let decodingError = MockDecodingError(message: "Decoding Error", statusCode: 0)
        let expectedErrorMessage = "Failed to decode response"
        let shoulReceiveErrorExpectation = expectation(description: "Error should receive.")

        let data = try XCTUnwrap(JSONEncoder().encode(decodingError))
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)
        
        // When & Then
        networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertEqual(error.message, expectedErrorMessage)
                    XCTAssertEqual(error.statusCode, NSURLErrorCannotDecodeRawData)
                    shoulReceiveErrorExpectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [shoulReceiveErrorExpectation], timeout: 1)
    }
    
    func test_request_with_async_await_failure_decoding_error() async throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 0
        let decodingError = MockDecodingError(message: "Decoding Error", statusCode: 0)
        let expectedErrorMessage = "Failed to decode response"

        let data = try XCTUnwrap(JSONEncoder().encode(decodingError))
        
        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)
        
        // When
        do {
            let _ = try await networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
        } catch let error as APIClientError {
            // Then
            XCTAssertEqual(error.message, expectedErrorMessage)
            XCTAssertEqual(error.statusCode, NSURLErrorCannotDecodeRawData)
        }
    }
    
    func test_request_with_combine_success_decoding_error() throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 209
        let mockNoneDecodableResponse = MockNoneDecodableResponse(nextPath: 1)
        let expectedErrorMessage = "Failed to decode response"
        let shoulReceiveErrorExpectation = expectation(description: "Error should receive.")
        
        let data = try XCTUnwrap(JSONEncoder().encode(mockNoneDecodableResponse))

        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)
        
        // When & Then
        networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertEqual(error.message, expectedErrorMessage)
                    XCTAssertEqual(error.statusCode, NSURLErrorCannotDecodeRawData)
                    shoulReceiveErrorExpectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [shoulReceiveErrorExpectation], timeout: 1)
    }
    
    func test_request_with_async_await_success_decoding_error() async throws {
        // Given
        let urlString = "http://localhost:8000"
        let statusCode = 209
        let mockNoneDecodableResponse = MockNoneDecodableResponse(nextPath: 1)
        let expectedErrorMessage = "Failed to decode response"
        
        let data = try XCTUnwrap(JSONEncoder().encode(mockNoneDecodableResponse))

        MockURLProtocol.createRequestHandler(urlString: urlString, statusCode: statusCode, data: data)
        
        // When
        do {
            let _ = try await networkManager.request(endpoint: .getRoot, responseType: MockClientRootResponse.self)
        } catch let error as APIClientError {
            // Then
            XCTAssertEqual(error.message, expectedErrorMessage)
            XCTAssertEqual(error.statusCode, NSURLErrorCannotDecodeRawData)
        }
    }
}
