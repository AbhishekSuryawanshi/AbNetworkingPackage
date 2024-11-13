//
//  NetworkError.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 09/11/24.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingFailed
    case requestFailed(String)         // Error message from server or URLSession
    case invalidResponse               // Invalid or unexpected response
    case networkUnavailable            // No network connection
    case unexpectedStatusCode(Int)     // Unexpected HTTP status code

    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .noData:
            return "No data received from the server."
        case .decodingFailed:
            return "Failed to decode the response data."
        case .requestFailed(let message):
            return "Request failed with message: \(message)"
        case .invalidResponse:
            return "The response received from the server was invalid."
        case .networkUnavailable:
            return "The network is unavailable. Please check your connection."
        case .unexpectedStatusCode(let code):
            return "Received unexpected status code: \(code)"
        }
    }
    
    // Conforming to Equatable to enable XCTAssertEqual in tests
    public static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.decodingFailed, .decodingFailed),
             (.invalidResponse, .invalidResponse),
             (.networkUnavailable, .networkUnavailable):
            return true
        case (.requestFailed(let lhsMessage), .requestFailed(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.unexpectedStatusCode(let lhsCode), .unexpectedStatusCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
