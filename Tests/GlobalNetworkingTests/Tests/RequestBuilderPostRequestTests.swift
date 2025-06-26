//
//  RequestBuilderPostRequestTests.swift
//  GlobalNetworkingTests
//
//  Created by Can Kurtur on 11.02.2025.
//

@testable import GlobalNetworking
import XCTest

final class RequestBuilderPostRequestTests: XCTestCase {
    enum MockPostRequests: Endpoint {
        case saveMovie(MovieSaveRequestData)
        case saveDirector(DirectorSaveRequestData)
        
        var path: String {
            switch self {
            case .saveMovie: 
                return "/movie"
            case .saveDirector:
                return "/director"
            }
        }
        
        var params: [String : Any]? {
            switch self {
            case .saveMovie(let data): return data.asDictionary
            case .saveDirector(let data): return data.asDictionary
            }
        }
        
        var method: HTTPMethod {
            return .post
        }
    }
    
    struct DirectorSaveRequestData: Encodable {
        let name: String
        let gender: String
    }
    
    struct MovieSaveRequestData: Encodable {
        let name: String
        let directors: [DirectorSaveRequestData]
    }
    
    func testRequestsWithSimpleData() {
        let directorData: DirectorSaveRequestData = .init(
            name: "Test director",
            gender: "Female"
        )
        
        let request = RequestBuilder.makeRequest(
            for: MockPostRequests.saveDirector(directorData),
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertEqual(request?.timeoutInterval, 10)
        XCTAssertEqual(request?.url?.absoluteString, "http://localhost:8000/director")
        XCTAssertEqual(request!.httpBody!.prettyPrintedJSONString!,
            """
            {
              "name" : "Test director",
              "gender" : "Female"
            }
            """
        )
    }
    
    func testRequestsWithNestedData() {
        let movieData: MovieSaveRequestData = .init(
            name: "Titanic",
            directors: [
                .init(name: "Director 1", gender: "Male"),
                .init(name: "Director 2", gender: "Female"),
            ])
        
        let request = RequestBuilder.makeRequest(
            for: MockPostRequests.saveMovie(movieData),
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertEqual(request?.timeoutInterval, 10)
        XCTAssertEqual(request?.url?.absoluteString, "http://localhost:8000/movie")
        XCTAssertEqual(request!.httpBody!.prettyPrintedJSONString!,
            """
            {
              "name" : "Titanic",
              "directors" : [
                {
                  "name" : "Director 1",
                  "gender" : "Male"
                },
                {
                  "name" : "Director 2",
                  "gender" : "Female"
                }
              ]
            }
            """
        )
    }
}
