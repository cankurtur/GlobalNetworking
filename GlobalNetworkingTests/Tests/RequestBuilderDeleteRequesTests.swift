//
//  RequestBuilderDeleteRequesTests.swift
//  GlobalNetworking
//
//  Created by Can Kurtur on 11.02.2025.
//

@testable import GlobalNetworking
import XCTest

final class RequestBuilderDeleteRequestTests: XCTestCase {
    enum MockDeleteRequestsEndpointItem: Endpoint {
        case deleteSomething(SomethingDeleteRequestData)
        
        var path: String {
            return "/something"
        }
        
        var params: [String : Any]? {
            switch self {
            case .deleteSomething(let data): return data.asDictionary
            }
        }
        
        var method: HTTPMethod {
            return .delete
        }
    }
    
    struct SomethingDeleteRequestData: Encodable {
        let id: Int
    }
    
    func testDeleteRequest() {
        let data: SomethingDeleteRequestData = .init(id: 1)
        
        let request = RequestBuilder.makeRequest(
            for: MockDeleteRequestsEndpointItem.deleteSomething(data),
            timeoutInterval: 10
        )
        
        XCTAssertNotNil(request)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertEqual(request?.timeoutInterval, 10)
        XCTAssertEqual(request?.url?.absoluteString, "http://localhost:8000/something")
        XCTAssertEqual(request!.httpBody!.prettyPrintedJSONString!,
            """
            {
              "id" : 1
            }
            """
        )
    }
}
