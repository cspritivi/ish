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
    @State private var showNewOrderSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome, \(viewModel.user?.firstName ?? "") \(viewModel.user?.lastName ?? "")")
                    .font(.title)
                    .fontWeight(.bold)
                
                if let creationDate = viewModel.userCreationDate {
                    Text("User since \(viewModel.formatDate(creationDate))")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Main action buttons
                Button(action: {
                    showNewOrderSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Create New Order")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Navigation links
                NavigationLinkWithIcon(
                    destination: OrderListView(),
                    icon: "list.bullet.rectangle",
                    title: "My Orders"
                )
                
                NavigationLinkWithIcon(
                    destination: MeasurementListView(),
                    icon: "ruler",
                    title: "My Measurements"
                )
                
                Spacer()
                
                // Log out button
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
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchUserDetails()
            }
            .sheet(isPresented: $showNewOrderSheet) {
                OrderCreationView()
            }
        }
    }
}

#Preview {
    AccountView()
}
