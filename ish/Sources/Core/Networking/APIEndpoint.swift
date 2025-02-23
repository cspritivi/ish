//
//  APIEndpoint.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/22/25.
//

enum APIEndpoint {
    case login(email: String, password: String)
    case signup(email: String, password: String, firstName: String, lastName: String)
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .signup:
            return "/auth/signup"
        }
    }
    
    var method: String {
        switch self {
        case .login, .signup:
            return "POST"
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return [
                "email" : email,
                "password" : password
            ]
        case .signup(let email, let password, let firstName, let lastName):
            return [
                "email" : email,
                "password" : password,
                "firstName" : firstName,
                "lastName" : lastName
            ]
        }
    }
}
