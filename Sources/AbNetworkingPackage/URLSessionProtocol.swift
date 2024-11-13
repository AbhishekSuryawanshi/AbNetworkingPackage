//
//  URLSessionProtocol.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 09/11/24.
//

import Foundation

@available(iOS 13.0.0, *)
public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
