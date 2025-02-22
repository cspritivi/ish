//
//  AuthenticationError.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//

import Foundation

enum AuthenticationError: Error {
    case invalidEmail
    case invalidPassword
    case networkError
    case userNotFound
    case serverError
    
    var errorMessage: String {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Password must contain at least 8 characters, including uppercase letters, lowercase letters, digits, and special characters"
        case .networkError:
            return "Network Error. Please try again"
        case .userNotFound:
            return "User not found"
        case .serverError:
            return "Server Error. Please try again later"
        }
    }
}
