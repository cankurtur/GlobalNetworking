//
//  NetworkManager.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 8.02.2025.
//

import Foundation
import Combine

/// Network manager that provides request methods for async/await, Combine, and callback-based API calls.
public final class NetworkManager<EndpointItem: Endpoint> {

    /// Default, URLSession, for all of the requests.
    private let session: URLSession
    
    /// Timeout interval per each request.
    private let timeoutInterval: TimeInterval
    
    /// Custom error type that provided by consumer.
    private let clientErrorType: APIError.Type
    
    /// Contains specific error codes to notify consumers when request's status code is in the list.
    /// Use `errorStatusCodeHandler` to listen these status codes in consumer side.
    private let errorStatusCodesToTrack: [Int]
    
    /// Callback for `errorStatusCodesToTrack`.

    private let errorStatusCodeHandler: ErrorStatusCodeHandler?
    
    /// Logger for network errors and responses.
    private let logger: NetworkLoggerProtocol
    private let successStatusCodes: ClosedRange<Int>
    
    /// Default, single, decoder for all of the requests.
    private lazy var decoder: JSONDecoder = {
        return .init()
    }()
    
    public init(
        session: URLSession = URLSession.shared,
        timeoutInterval: TimeInterval = 10,
        clientErrorType: APIError.Type,
        errorStatusCodesToTrack: [Int] = [],
        errorStatusCodeHandler: ErrorStatusCodeHandler? = nil,
        logger: NetworkLoggerProtocol,
        successStatusCodes: ClosedRange<Int> = 200...209
    ) {
        self.session = session
        self.timeoutInterval = timeoutInterval
        self.clientErrorType = clientErrorType
        self.errorStatusCodesToTrack = errorStatusCodesToTrack
        self.errorStatusCodeHandler = errorStatusCodeHandler
        self.logger = logger
        self.successStatusCodes = successStatusCodes
    }
}

// MARK: - NetworkManagerProtocol

extension NetworkManager: NetworkManagerProtocol {
    /// Sends a network request and returns a publisher that emits a decoded response or an error.
    /// - Parameters:
    ///   - endpoint: The API endpoint to request.
    ///   - responseType: The expected response type, conforming to `Decodable`.
    /// - Returns: A publisher that emits the decoded response of type `T` or an `APIClientError`.
    public func request<T>(endpoint: EndpointItem, responseType: T.Type) -> AnyPublisher<T, APIClientError> where T : Decodable {
        logger.logRequest(endpoint)
        
        guard let request = RequestBuilder.makeRequest(for: endpoint, timeoutInterval: timeoutInterval) else {
            logger.logResponse(.failure(reason: APIClientError.badRequest.debugMessage, endpoint: endpoint))
            return Fail(error: APIClientError.badRequest)
                .eraseToAnyPublisher()
        }
        
        logger.logCurlString(request)
        
        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response in
                
                guard let statusCode = response.code else {
                    throw APIClientError.invalidStatusCode
                }
                
                if self.successStatusCodes.contains(statusCode) {
                    return try self.handleSucceedRequest(data: data, endpoint: endpoint, responseType: responseType)
                } else {
                    throw self.handleFailedRequest(response: response, data: data, endpoint: endpoint)
                }
                
            }
            .mapError { error -> APIClientError in
                guard let error = error as? APIClientError else {
                    self.logger.logResponse(.failure(reason: APIClientError.networkError.debugMessage, endpoint: endpoint))
                    return APIClientError.networkError
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    /// Sends an asynchronous network request and returns the decoded response.
    /// - Parameters:
    ///   - endpoint: The API endpoint to request.
    ///   - responseType: The expected response type, conforming to `Decodable`.
    /// - Returns: A decoded response of type `T`.
    /// - Throws: An `APIClientError` if the request fails.
    public func request<T>(endpoint: EndpointItem, responseType: T.Type) async throws -> T where T : Decodable {
        logger.logRequest(endpoint)
        
        guard let request = RequestBuilder.makeRequest(for: endpoint, timeoutInterval: timeoutInterval) else {
            logger.logResponse(.failure(reason: APIClientError.badRequest.debugMessage, endpoint: endpoint))
            throw APIClientError.badRequest
        }
        logger.logCurlString(request)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let statusCode = response.code else {
                throw APIClientError.invalidStatusCode
            }
            
            if successStatusCodes.contains(statusCode) {
                return try handleSucceedRequest(data: data, endpoint: endpoint, responseType: responseType)
            } else {
                throw handleFailedRequest(response: response, data: data, endpoint: endpoint)
            }
        } catch let error {
            guard let error = error as? APIClientError else {
                self.logger.logResponse(.failure(reason: APIClientError.networkError.debugMessage, endpoint: endpoint))
                throw APIClientError.networkError
            }
            throw error
        }
    }
    
    /// Sends a network request using an escaping closure for completion handling.
    /// - Parameters:
    ///   - endpoint: The API endpoint to request.
    ///   - responseType: The expected response type, conforming to `Decodable`.
    ///   - completion: A completion handler that returns a `Result` containing either the decoded response or an `APIClientError`.
    public func request<T>(endpoint: EndpointItem, responseType: T.Type, completion: @escaping NetworkHandler<T>) where T : Decodable {
        Task {
            do {
                let response = try await request(endpoint: endpoint, responseType: responseType)
                completion(.success(response))
            } catch  {
                completion(.failure(error as? APIClientError ?? .networkError))
            }
        }
    }
}

// MARK: - Internal Methods

/// /// Handles success case from API request.
/// - Parameters:
///   - data: Given data from request.
///   - endpoint: Given endpoint.
///   - responseType: Response type provided by consumer.
/// - Returns: Decoded T type object.
private extension NetworkManager {
    func handleSucceedRequest<T: Decodable>(
        data: Data,
        endpoint: EndpointItem,
        responseType: T.Type
    ) throws -> T where T : Decodable {
        logger.logResponse(.success(data: data, endpoint: endpoint))

        if data.isEmpty, let emptyResponse = EmptyResponse() as? T {
            return emptyResponse
        }
        
        do {
            let decodedObject = try self.decoder.decode(responseType, from: data)
            return decodedObject
        } catch {
            let decodingError = APIClientError.decodingError(error: error as? DecodingError)
            logger.logResponse(.failure(reason: decodingError.debugMessage, endpoint: endpoint))
            throw decodingError
        }
    }
    
    /// Handles failure case from API request.
    /// - Parameters:
    ///   - response: Given response.
    ///   - data: Given data from request.
    ///   - endpoint: Given endpoint.
    /// - Returns: Generic APIClientError for all of the consumers
    func handleFailedRequest(
        response: URLResponse,
        data: Data?,
        endpoint: EndpointItem
    ) -> APIClientError {
        guard response.code != NSURLErrorTimedOut else {
            logger.logResponse(.failure(reason: APIClientError.timeout.debugMessage, endpoint: endpoint))
            return APIClientError.timeout
        }
        
        if let statusCode = response.code, errorStatusCodesToTrack.contains(statusCode) {
            errorStatusCodeHandler?(statusCode)
        }
        
        do {
            guard let data = data else {
                logger.logResponse(.failure(reason: APIClientError.networkError.debugMessage, endpoint: endpoint))
                return APIClientError.networkError
            }
            
            let clientError = try self.decoder.decode(self.clientErrorType, from: data)
            clientError.statusCode = response.code
            logger.logResponse(.failure(reason: clientError.error, endpoint: endpoint, data: data))
            return APIClientError.handledError(error: clientError)
        } catch {
            let decodingError = APIClientError.decodingError(error: error as? DecodingError)
            logger.logResponse(.failure(reason: decodingError.debugMessage, endpoint: endpoint))
            return decodingError
        }
    }
}
