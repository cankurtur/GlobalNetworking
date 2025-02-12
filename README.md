# GlobalNetworking

`GlobalNetworking` is a powerful networking framework that simplifies making network requests and handling errors in Swift. With `GlobalNetworking`, you can effortlessly send network requests and manage any errors that occur, making it the perfect tool for building robust, network-dependent applications.

## Table of contents
- :mag: [Requirements](#requirements)
- :rocket: [Installation](#installation)
- :books: [Usage](#usage)
- :key: [Licence](#licence)

## Requirements

`GlobalNetworking` is written in Swift 5.0+ and is compatible with iOS 16.0+.

## Installation
### Swift Package Manager

1. In Xcode, select File > Swift Packages > Add Package Dependency.
1. Follow the prompts using the URL for this repository.
1. Select the `GlobalNetworking`-prefixed libraries you want to use.
1. Check-out the version that you want.
1. Start coding!

## Usage

The `GlobalNetworking` framework provides functionality for handling network requests and errors in Swift. It supports API requests using Combine, async/await, and escaping closures.

### Supporting

`NetworkManagerProcol` is a Swift protocol that defines a contract for network management operations. It provides three different approaches to handle network requests: Combine-based, async/await, and completion handler-based implementations.

The `EndpointItem` associated type must conform to the `Endpoint` protocol. It defines the type of endpoint used for network requests, allowing implementations to specify their own endpoint type while maintaining type safety.

```swift
public protocol NetworkManagerProtocol {
    associatedtype EndpointItem: Endpoint
    func request<T: Decodable>(endpoint: EndpointItem, responseType: T.Type) -> AnyPublisher<T, APIClientError>
    func request<T: Decodable>(endpoint: EndpointItem, responseType: T.Type) async throws -> T
    func request<T: Decodable>(endpoint: EndpointItem, responseType: T.Type, completion: @escaping NetworkHandler<T>)
}
```

### Bases

- `Endpoint`: A protocol that defines the basic structure and functionality of API endpoints.
- `APIError`: A generic error type for the networking layer. You can define your own error type by conforming to this protocol.
- `APIClientError`: Defines various error types that can occur in APIClient.
- `NetworkManagerProtocol`: A protocol that defines the requirements for a network manager to handle API requests using Combine, async/await, and callback-based approaches.
- `EmptyResponse`: A placeholder class representing an empty response, used when an API response does not contain any data.

### Creating Instance

The NetworkManager is typically initialized as a private property in your class:

```swift
import GlobalNetworking

final class YourClass {
        private let networkManager = NetworkManager<YourEndpointItem>(clientErrorType: ClientError.self, logger: YourLogger())
}

```

#### Generic Type

`NetworkManager<YourEndpointItem>` requires your custom endpoint type that conforms to the `Endpoint` protocol.

#### Parameters

`clientErrorType`: Your custom error type that handles API errors
`logger`: Custom logger instance for network request logging

### Network Logger

To log your requests for debugging purposes, `GlobalNetworking` provides a default logger. However, you can also use your own logger by conforming to the `NetworkLoggerProtocol`. Once you create your custom logger class, you can pass it when initializing the network manager.

```swift
import GlobalNetworking

class YourLogger: NetworkLoggerProtocol {
    func logCurlString(_ urlRequest: URLRequest?) {
        // Your Log
    }
    
    func logRequest(_ endpoint: any Endpoint) {
        // Your Log
    }
    
    func logResponse(_ responseLogging: ResponseLogging) {
        // Your Log
    }
}

```

### Endpoint Extension

```swift
import GlobalNetworking

public extension Endpoint {

    var baseUrl: String {
        return "Your_base_url"
    }

    var params: [String: Any]? {
        return nil
    }

    var url: String {
        return "\(baseUrl)\(path)"
    }

    var headers: HTTPHeaders? {
        let headers = defaultHeaders
        return headers
    }
}

```
- The `Endpoint` protocol, provided by the `GlobalNetworking` framework, adds default behavior for properties that need to be implemented by endpoints conforming to this protocol.
- The `baseUrl` property returns the abstract API base URL.
- The `params` property returns a nil value as there are no default parameters for this endpoint.
- The `url` property returns the full URL of the endpoint by concatenating the base URL and the endpoint’s path.
- The `headers` property returns a `HTTPHeaders` object containing the base headers defined in the baseHeaders property.

These default implementations make endpoint creation easier and more concise while still offering flexibility to override them when needed.

### Client Error

A generic error type for the error layer. To cast network errors to your own error model, provide your own type by conforming to this protocol.

```swift
import GlobalNetworking

public class ClientError: APIError {
    public var error: String
    public var statusCode: Int?
    public var yourOwnStringConfig: String?
    public var yourOwnIntConfig: Int?
}

```
### Implementation

Create your own `EndpointItem` as needed to customize the behavior and properties for your specific API endpoints.

```swift
import GlobalNetworking

enum YourEndpointItem: Endpoint {
    
    case yourRequest
    case yourOtherRequest(yourParameter: String)
    
    var path: String {
        switch self {
        case .yourRequest:
            return "/somePath"
        case .yourOtherRequest(let yourParameter):
            return "/newPath/\(yourParameter)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .yourRequest, .yourOtherRequest:
            return .get
        }
    }

}

```

### Response 

Create your own response object as needed to match the structure and data returned by your API, ensuring it aligns with the requirements of your application.

```swift
import Foundation

struct YourResponse: Codable {
    let success: Bool?
}

```
## Licence

`GlobalNetworking` is available under the MIT license. See the LICENSE file for more info.
