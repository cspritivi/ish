//
//  SignUpViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//
import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    @Published var confirmPasswordError = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var firstNameError = ""
    @Published var lastNameError = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var isValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        EmailValidator.validate(email) &&
        PasswordValidator.validate(password) &&
        password == confirmPassword
    }
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $firstName
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] name in
                if !name.isEmpty && name.count < 2 {
                    self?.firstNameError = "First name must be at least 2 characters"
                } else {
                    self?.firstNameError = ""
                }
            }
            .store(in: &cancellables)
        
        $lastName
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] name in
                if !name.isEmpty && name.count < 2 {
                    self?.lastNameError = "Last name must be at least 2 characters"
                } else {
                    self?.lastNameError = ""
                }
            }
            .store(in: &cancellables)
        
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
        
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] password, confirmPassword in
                if !confirmPassword.isEmpty && password != confirmPassword {
                    self?.confirmPasswordError = "Passwords do not match"
                } else {
                    self?.confirmPasswordError = ""
                }
            }
            .store(in: &cancellables)
    }
    
    func signUp() {
        guard isValid else { return }
        isLoading = true
        
        Task {
            do {
                let response = try await AuthService.shared.signup(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName
                )
                await MainActor.run {
                    isLoading = false
                        // Handle successful signups (save token, update UI state, etc.)
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.errorMessage
                    showError = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "An unexpected error occurred"
                    showError = true
                }
            }
        }
        
    }
}
