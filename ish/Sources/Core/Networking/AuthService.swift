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
    @Published var isAuthenticated = false
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            
            guard let self = self else { return }
            
            
            if let userId = user?.uid {
                Task { @MainActor in
                    do {
                        let user = try await self.fetchUser(userId: userId)
                        await MainActor.run {
                            self.currentUser = user
                            self.isAuthenticated = true
                        }
                    } catch {
                        print("Error fetching user: \(error)")
                        self.currentUser = nil
                        self.isAuthenticated = false
                    }
                }
            } else {
                Task { @MainActor in
                    self.currentUser = nil
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    deinit {
        if let handler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    func getCurrentUser() async throws -> User? {
        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }
        return try await fetchUser(userId: userId)
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    func login(email: String, password: String) async throws -> User {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            let user = try await fetchUser(userId: result.user.uid)
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
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
        case AuthErrorCode.wrongPassword.rawValue:
            return .serverError("Incorrect password")
        case AuthErrorCode.invalidEmail.rawValue:
            return .serverError("Invalid email format")
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .serverError("Email already in use")
        case AuthErrorCode.userNotFound.rawValue:
            return .serverError("No account found with this email")
        default:
            return .serverError("An error occurred. Please try again")
        }
    }
    
}
