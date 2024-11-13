import XCTest
@testable import AbNetworkingPackage

final class APIServiceManagerTests: XCTestCase {

    func testBuildRequestWithGetMethod() async {
        let networkService = NetworkService()
        let apiServiceManager = APIServiceManager(networkService: networkService)
        
        // Using JSONPlaceholder API for an actual GET request
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        // Build the request
        let request = await apiServiceManager.buildRequest(
            to: url,
            withMethod: .GET,
            headers: ["Custom-Header": "HeaderValue"],
            parameters: ["userId": "1"]
        )
        
        XCTAssertEqual(request.url?.absoluteString, "\(url)?userId=1")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Custom-Header"), "HeaderValue")
        
        // Verify that parameters are added as query items for GET request
        XCTAssertEqual(request.url?.query, "userId=1")
    }

    func testBuildRequestWithPostMethod() async {
        let networkService = NetworkService()
        let apiServiceManager = APIServiceManager(networkService: networkService)
        
        // Using JSONPlaceholder API for an actual POST request
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        // Build the request
        let request = await apiServiceManager.buildRequest(
            to: url,
            withMethod: .POST,
            headers: ["Content-Type": "application/json"],
            parameters: ["title": "foo", "body": "bar", "userId": "1"]
        )
        
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        
        // Verify that parameters are included in the HTTP body for POST request
        if let body = request.httpBody,
           let json = try? JSONSerialization.jsonObject(with: body) as? [String: String] {
            XCTAssertEqual(json["title"], "foo")
            XCTAssertEqual(json["body"], "bar")
            XCTAssertEqual(json["userId"], "1")
        } else {
            XCTFail("Expected JSON body in the POST request")
        }
    }
}

