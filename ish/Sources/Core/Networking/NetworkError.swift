//
//  NetworkError.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/22/25.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case serverError(String)
    case unauthorized
    case decodingError
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "Invalid data received"
        case .serverError(let message):
            return message
        case .unauthorized:
            return "Invalid Credentials"
        case .decodingError:
            return "Error processing response"
        }
    }
}
