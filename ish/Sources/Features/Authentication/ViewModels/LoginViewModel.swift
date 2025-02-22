//
//  LoginViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var showSignUp = false
    @Published var errorMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var isValid: Bool {
        EmailValidator.validate(email) && PasswordValidator.validate(password)
    }
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $email
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] email in
                if !email.isEmpty && !EmailValidator.validate(email) {
                    self?.emailError = "Please enter a valid email"
                } else {
                    self?.emailError = ""
                }
            }
            .store(in: &cancellables)
        
        $password
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] password in
                if !password.isEmpty && !PasswordValidator.validate(password) {
                    self?.passwordError = PasswordValidator.getFailureReason(password)
                } else {
                    self?.passwordError = ""
                }
            }
            .store(in: &cancellables)
    }
    
    
    func login() {
        guard isValid else { return }
        isLoading = true
        
        Task {
            do {
                let response = try await AuthService.shared.login(
                    email: email,
                    password: password
                )
                await MainActor.run {
                    isLoading = false
                    // Handle successful login (save token, update UI state, etc.)
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "An unexpected error occurred"
                    showError = true
                }
            }
        }
    }
}
