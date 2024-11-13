//
//  NetworkServiceTest.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 13/11/24.
//

import XCTest
@testable import AbNetworkingPackage

final class NetworkServiceTests: XCTestCase {

    func testSuccessfulNetworkRequest() async {
        // Arrange
        let networkService = NetworkService()
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
        let request = URLRequest(url: url)
        
        // Act
        let result = await networkService.performNetworkRequest(request: request)
        
        // Assert
        switch result {
        case .success(let data):
            XCTAssertFalse(data.isEmpty, "Expected non-empty data from the API")
            
            // Optionally, parse JSON to confirm structure
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                XCTAssertNotNil(json["id"], "Expected 'id' field in the response")
                XCTAssertEqual(json["id"] as? Int, 1, "Expected 'id' field to be 1")
            } else {
                XCTFail("Failed to parse JSON data")
            }
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }

    func testNetworkRequestWithUnexpectedStatusCode() async {
        // Arrange
        let networkService = NetworkService()
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/99999")!  // Non-existent post ID
        let request = URLRequest(url: url)
        
        // Act
        let result = await networkService.performNetworkRequest(request: request)
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError.unexpectedStatusCode(404), "Expected unexpectedStatusCode error with 404 code")
        }
    }

    func testNetworkRequestFailureWithError() async {
        // Arrange
        let invalidURL = URL(string: "https://invalidurl.example.com")!  // Invalid URL to simulate network error
        let networkService = NetworkService()
        let request = URLRequest(url: invalidURL)
        
        // Act
        let result = await networkService.performNetworkRequest(request: request)
        
        // Assert
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            // Check that the error is 'requestFailed' and contains the correct error code
            if case .requestFailed(let errorMessage) = error {
                let expectedErrorCode = URLError.cannotFindHost.rawValue
                XCTAssertTrue(errorMessage.contains("A server with the specified hostname could not be found.") ||
                              errorMessage.contains("The operation couldn’t be completed."),
                              "Expected error message indicating cannot find host")
            } else {
                XCTFail("Expected requestFailed error with cannotFindHost code")
            }
        }
    }
}
