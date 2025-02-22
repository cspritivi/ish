//
//  AuthService.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/22/25.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
    let user: User
}

struct ErrorResponse: Codable {
    let message: String
}

class AuthService {
    static let shared = AuthService()
    private let apiClient = APIClient.shared
    
    private init() {}
    
    func login(email: String, password: String) async throws -> AuthResponse {
        return try await apiClient.request(.login(email: email, password: password))
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String) async throws -> AuthResponse {
        return try await apiClient.request(.signup(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        ))
    }
    
}
