//
//  APIClient.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/22/25.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL = "YOUR_BASE_URL" // Replace with your actual API base URL
    
    private init() {}
    
    func request<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.serverError(errorResponse.message)
            }
            
            throw NetworkError.serverError("Unknown error occurred")
        }
    }
}

