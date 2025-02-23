//
//  AccountViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/23/25.
//
// Sources/Features/Account/ViewModels/AccountViewModel.swift
import Foundation
import FirebaseAuth

class AccountViewModel: ObservableObject {
    @Published var user: User?
    @Published var userCreationDate: Date?
    
    init() {
        fetchUserDetails()
    }
    
    func fetchUserDetails() {
        Task {
            do {
                self.user = try await AuthService.shared.getCurrentUser()
                if let timestamp = Auth.auth().currentUser?.metadata.creationDate {
                    await MainActor.run {
                        self.userCreationDate = timestamp
                    }
                }
            } catch {
                print("Error fetching user details: \(error)")
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func signOut() {
        Task {
            do {
                try await AuthService.shared.signOut()
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
}
