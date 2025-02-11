//
//  MockURLProtocol.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    static var requestFailed = false
    static var connectionFailed = false
    
    static func resetMockData() {
        requestHandler = nil
        requestFailed = false
        connectionFailed = false
    }
    
    /// Fatal error avoiding.
    static func populateRequestHandler() {
        requestHandler = { request in
            let response = HTTPURLResponse(
                url: URL(string: "http://localhost:8000")!,
                statusCode: 0,
                httpVersion: nil,
                headerFields: nil)!
            return (response, Data())
        }
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        do {
            guard let handler = MockURLProtocol.requestHandler else {
                fatalError("There is no handler.")
            }
            
            if MockURLProtocol.connectionFailed {
                throw NSError(
                    domain: "com.example.errorDomain",
                    code: 500,
                    userInfo: [NSLocalizedDescriptionKey: "Connection Failed"]
                )
            }
            
            let (response, data) = try handler(request)
            
            if MockURLProtocol.requestFailed {
                client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: .notAllowed)
            } else {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }
}
