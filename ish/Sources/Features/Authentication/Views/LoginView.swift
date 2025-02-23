//
//  LoginView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showPassword = false
    var body: some View {
        VStack(spacing: 20) {
            // Logo or App Name
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Email field
            VStack(alignment: .leading) {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                
                if !viewModel.emailError.isEmpty {
                    Text(viewModel.emailError)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            
            // Password field
            VStack(alignment: .leading) {
                HStack {
                    if showPassword {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(.gray)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !viewModel.passwordError.isEmpty {
                    Text(viewModel.passwordError)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            
            // Login Button
            Button(action: viewModel.login) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .disabled(!viewModel.isValid || viewModel.isLoading)
            
            
            // Sign Up Link
            NavigationLink(destination: SignUpView()) {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            }
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
    NavigationView {
        LoginView()
    }
}
