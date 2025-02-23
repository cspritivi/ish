//
//  AccountView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/23/25.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(viewModel.user?.firstName ?? "") \(viewModel.user?.lastName ?? "")")
                .font(.title)
                .fontWeight(.bold)
            
            if let creationDate = viewModel.userCreationDate {
                Text("User since \(viewModel.formatDate(creationDate))")
                    .foregroundColor(.gray)
            }
            
            Button(action: viewModel.signOut) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            viewModel.fetchUserDetails()
        }
    }
}

#Preview {
    AccountView()
}
