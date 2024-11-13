//
//  StandardRequestHelper.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 09/11/24.
//

import Foundation

public struct StandardRequestHelper {
    public static func createRequest(
        url: URL,
        method: RequestType,
        headers: [String: String] = [:],
        parameters: [String: Any]? = nil
    ) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Apply default headers first, then custom headers (custom headers override defaults)
        let allHeaders = HTTPHeaders.defaultHeaders().merging(headers) { (_, custom) in custom }
        allHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        // Add parameters based on the request type
        if let parameters = parameters {
            switch method {
            case .GET:
                // For GET requests, add parameters as query items
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                    request.url = urlComponents.url
                }
            case .POST, .PUT, .DELETE:
                // For POST, PUT, DELETE, add parameters as JSON body
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        return request
    }
}
