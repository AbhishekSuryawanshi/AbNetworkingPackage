//
//  APIServiceManager.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 09/11/24.
//

import Foundation

@available(iOS 13.0.0, *)

public actor APIServiceManager {
    private let networkService: NetworkService
    
    public init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // Method to build the request and return it synchronously
    public func buildRequest(
        to url: URL,
        withMethod method: RequestType,
        headers: [String: String] = [:],
        parameters: [String: Any]? = nil
    ) -> URLRequest {
        
        return StandardRequestHelper.createRequest(
            url: url,
            method: method,
            headers: headers,
            parameters: parameters
        )
    }
}
