//
//  OrderListViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/ViewModels/OrderListViewModel.swift
import Foundation
import FirebaseAuth
import Combine

class OrderListViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var filteredOrders: [Order] = []
    @Published var selectedStatus: OrderStatus?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupStatusFilter()
    }
    
    private func setupStatusFilter() {
        $selectedStatus
            .sink { [weak self] status in
                guard let self = self else { return }
                if let status = status {
                    self.filteredOrders = self.orders.filter { $0.status == status }
                } else {
                    self.filteredOrders = self.orders
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchOrders() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showError = true
            errorMessage = "User not logged in"
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let fetchedOrders = try await OrderService.shared.getOrders(for: userId)
                await MainActor.run {
                    self.orders = fetchedOrders.sorted { $0.updatedAt > $1.updatedAt }
                    self.filteredOrders = self.orders
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    func deleteOrder(id: String) {
        isLoading = true
        
        Task {
            do {
                try await OrderService.shared.deleteOrder(id: id)
                await MainActor.run {
                    self.orders.removeAll { $0.id == id }
                    self.filteredOrders.removeAll { $0.id == id }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

