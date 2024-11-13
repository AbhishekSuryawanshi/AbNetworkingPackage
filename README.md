# AbNetworkingPackage

A Swift networking package designed to simplify API calls with Swift's concurrency model, using `URLSession`, actors, and custom error handling.

## Features

- **Simple API request building** with `APIServiceManager`.
- **Network request handling** with `NetworkService`.
- **Customizable headers** and **parameter encoding** for different request types.
- **Error handling** with custom `NetworkError` for improved debugging.
- Compatible with **iOS 13.0+** and **macOS 10.15+**.

## Installation

To use `AbNetworkingPackage` in your project, add it via Swift Package Manager.

### Swift Package Manager

1. In Xcode, go to **File > Add Packages**.
2. Enter the repository URL: `https://github.com/AbhishekSuryawanshi/AbNetworkingPackage.git`.
3. Select the latest version or specify a version if needed.
4. Add it to your project.

## Components

The package consists of two main components:

1. **APIServiceManager**: An actor responsible for building and coordinating API requests.
2. **NetworkService**: A class that performs the actual network requests.

### APIServiceManager

- **`buildRequest(to:withMethod:headers:parameters:)`**: Builds a `URLRequest` with the specified parameters.
  - `to`: The `URL` of the API endpoint.
  - `withMethod`: The HTTP method, specified as `RequestType` (`GET`, `POST`, `PUT`, `DELETE`).
  - `headers`: Optional headers for the request.
  - `parameters`: Optional parameters to include as query items or JSON body, based on the HTTP method.

### NetworkService

- **`performNetworkRequest(request:)`**: Executes the network request and returns a result containing either the data or a `NetworkError`.

### NetworkError

The `NetworkError` enum provides detailed error handling for network requests.

- **Cases**:
  - `.invalidURL`: Invalid URL provided.
  - `.noData`: No data received from the server.
  - `.decodingFailed`: Failed to decode the response data.
  - `.requestFailed(String)`: Request failed with a specific error message.
  - `.invalidResponse`: Response from the server was invalid.
  - `.networkUnavailable`: Network connection is unavailable.
  - `.unexpectedStatusCode(Int)`: Received an unexpected HTTP status code.

## Usage

### Importing the Package

After installing, import `AbNetworkingPackage` in the files where you plan to use it:

```swift
import AbNetworkingPackage
```

### Example Usage

#### Step 1: Initialize `APIServiceManager` and `NetworkService`

```swift
let networkService = NetworkService() // Initialize the network service
let apiServiceManager = APIServiceManager(networkService: networkService) // Inject network service into API manager
```

#### Step 2: Make a GET Request

Let’s say you want to fetch posts from the [JSONPlaceholder API](https://jsonplaceholder.typicode.com/posts).

```swift
import Foundation

func fetchPosts() async {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

    // Build the request
    let request = await apiServiceManager.buildRequest(to: url, withMethod: .GET)

    // Perform the network request
    let result = await networkService.performNetworkRequest(request: request)

    // Handle the result
    switch result {
    case .success(let data):
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            print("Fetched posts:", posts)
        } catch {
            print("Failed to decode JSON:", error)
        }
    case .failure(let error):
        print("API call failed with error:", error.localizedDescription)
    }
}
```

#### Step 3: Define a Model for Decoding JSON

To decode the JSON response, create a `Post` struct:

```swift
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
```

### POST Request Example

To make a `POST` request with JSON parameters, you can use a similar approach:

```swift
func createPost() async {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    // Parameters for the POST request
    let parameters: [String: Any] = [
        "title": "foo",
        "body": "bar",
        "userId": 1
    ]
    
    // Build the POST request
    let request = await apiServiceManager.buildRequest(to: url, withMethod: .POST, parameters: parameters)

    // Perform the network request
    let result = await networkService.performNetworkRequest(request: request)

    // Handle the result
    switch result {
    case .success(let data):
        if let response = String(data: data, encoding: .utf8) {
            print("Response:", response)
        }
    case .failure(let error):
        print("API call failed with error:", error.localizedDescription)
    }
}
```

## Error Handling

`AbNetworkingPackage` provides detailed error handling through the `NetworkError` enum, allowing you to identify specific issues.

Example of handling errors:

```swift
switch error {
case .invalidURL:
    print("The URL provided is invalid.")
case .noData:
    print("No data received from the server.")
case .requestFailed(let message):
    print("Request failed with message:", message)
default:
    print("An unknown error occurred.")
}
```

## Testing

The package includes tests for `APIServiceManager` and `NetworkService`, covering both success and failure cases.

To run the tests:

1. Clone the repository.
2. Open Terminal, navigate to the repository’s root, and run:
   
   ```bash
   swift test
   ```

## Contributing

Contributions are welcome! If you’d like to contribute to `AbNetworkingPackage`, follow these steps:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes and commit them with clear messages.
4. Push your changes to your forked repository.
5. Create a pull request to the main repository.
