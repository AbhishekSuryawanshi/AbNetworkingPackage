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
