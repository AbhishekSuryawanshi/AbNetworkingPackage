//
//  HTTPHeader.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 09/11/24.
//

import Foundation

public struct HTTPHeaders {
    public static func defaultHeaders() -> [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    // Function to combine default headers with custom headers
    public static func combine(headers: [String: String]) -> [String: String] {
        return defaultHeaders().merging(headers) { (_, custom) in custom }
    }
}
