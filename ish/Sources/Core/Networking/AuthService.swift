//
//  AuthService.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/22/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthResponse: Codable {
    let token: String
    let user: User
}

struct ErrorResponse: Codable {
    let message: String
}

class AuthService: ObservableObject {
    static let shared = AuthService()
    @Published var currentUser: User?
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func login(email: String, password: String) async throws -> User {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            let user = try await fetchUser(userId: result.user.uid)
            await MainActor.run {
                self.currentUser = user
            }
            return user
        } catch {
            throw self.handleFirebaseError(error)
        }
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String) async throws -> User {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            
            let user = User(id: result.user.uid,
                            email: email,
                            firstName: firstName,
                            lastName: lastName)
            
            try await db.collection("users").document(user.id).setData([
                "email" : user.email,
                "firstName" : user.firstName,
                "lastName" : user.lastName
            ])
            
            await MainActor.run {
                self.currentUser = user
            }
            return user
        } catch {
            throw self.handleFirebaseError(error)
        }
    }
    
    private func fetchUser(userId: String) async throws -> User {
        let document = try await db.collection("users").document(userId).getDocument()
        guard let data = document.data() else {
            throw NetworkError.invalidData
        }
        return User(id: userId,
                    email: data["email"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "")
    }
    
    private func handleFirebaseError(_ error: Error) -> NetworkError {
        let authError = error as NSError
        switch authError.code {
        case AuthErrorCode.wrongPassword.rawValue,
            AuthErrorCode.invalidEmail.rawValue:
            return .unauthorized
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .serverError("Email already in use")
        default:
            return .serverError(error.localizedDescription)
        }
        
    }
    
}
