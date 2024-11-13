//
//  NetworkHandler.swift
//  AbNetworkingPackage
//
//  Created by Abhishek Suryawanshi on 10/11/24.
//

import Foundation

@available(iOS 13.0.0, *)
public class NetworkService {
    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func performNetworkRequest(request: URLRequest) async -> Result<Data, NetworkError> {
        guard Reachability.isConnectedToNetwork() else {
            return .failure(.networkUnavailable)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                return .success(data)
            } else {
                return .failure(.unexpectedStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1))
            }
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
}
