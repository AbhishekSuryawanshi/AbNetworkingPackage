//
//  ImageUploadHelper.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 09/11/24.
//

import Foundation

public struct ImageUploadHelper {
    public static func createMultipartRequest(
        url: URL,
        image: Data,
        imageName: String,
        parameters: [String: String]?,
        headers: [String: String] = [:]
    ) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Use HTTPHeaders to combine default headers with custom headers
        let allHeaders = HTTPHeaders.combine(headers: headers)
        allHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        // Create multipart form body
        var body = Data()
        
        // Add text parameters
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(image)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        return request
    }
}
