//
//  SignUpView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // First Name Field
            VStack(alignment: .leading) {
                TextField("First Name", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.words)
                if !viewModel.firstNameError.isEmpty {
                    Text(viewModel.firstNameError)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            
            // Last Name Field
            VStack(alignment: .leading) {
                TextField("Last Name", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.words)
                if !viewModel.lastNameError.isEmpty {
                    Text(viewModel.lastNameError)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            
            // Email Field
            VStack(alignment: .leading) {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                
                if !viewModel.emailError.isEmpty {
                    Text(viewModel.emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            // Password Field
            VStack(alignment: .leading) {
                HStack {
                    if showPassword {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !viewModel.passwordError.isEmpty {
                    Text(viewModel.passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            // Confirm Password Field
            VStack(alignment: .leading) {
                HStack {
                    if showConfirmPassword {
                        TextField("Confirm Password", text: $viewModel.confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    }
                    
                    Button(action: { showConfirmPassword.toggle() }) {
                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !viewModel.confirmPasswordError.isEmpty {
                    Text(viewModel.confirmPasswordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            // Sign Up Button
            Button(action: viewModel.signUp) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!viewModel.isValid || viewModel.isLoading)
            
            // Back to Login
            Button("Already have an account? Login") {
                dismiss()
            }
            .foregroundColor(.blue)
        }
        .padding()
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    SignUpView()
}
