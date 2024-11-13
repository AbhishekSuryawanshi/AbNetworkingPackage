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
    
    // Public method to build a standard request
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
    
    // Public method to upload an image using multipart/form-data
    public func uploadImage(
        to url: URL,
        image: Data,
        imageName: String,
        parameters: [String: String]? = nil,
        headers: [String: String] = [:]
    ) async -> Result<Data, NetworkError> {
        
        // Use ImageUploadHelper to create a multipart/form-data request
        let request = ImageUploadHelper.createMultipartRequest(
            url: url,
            image: image,
            imageName: imageName,
            parameters: parameters,
            headers: headers
        )
        
        // Perform the upload request using networkService
        return await networkService.performNetworkRequest(request: request)
    }
}
