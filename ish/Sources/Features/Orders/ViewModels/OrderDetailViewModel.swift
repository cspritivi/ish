//
//  OrderDetailViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/ViewModels/OrderDetailViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class OrderDetailViewModel: ObservableObject {
    @Published var order: Order
    @Published var measurements: Measurements?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var showConfirmationDialog = false
    @Published var showSuccessMessage = false
    
    init(order: Order) {
        self.order = order
        fetchMeasurements()
    }
    
    func fetchMeasurements() {
        isLoading = true
        
        Task {
            do {
                let snapshot = try await FirebaseFirestore.Firestore.firestore()
                    .collection("measurements")
                    .document(order.measurementsId)
                    .getDocument()
                
                if snapshot.exists {
                    let measurements = try Measurements.from(snapshot)
                    await MainActor.run {
                        self.measurements = measurements
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.isLoading = false
                    }
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
    
    func cancelOrder() {
        isLoading = true
        
        Task {
            do {
                try await OrderService.shared.updateOrderStatus(orderId: order.id, status: .cancelled)
                await MainActor.run {
                    self.order.status = .cancelled
                    self.isLoading = false
                    self.showSuccessMessage = true
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
    
    func getStatusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .draft:
            return .gray
        case .pending:
            return .orange
        case .confirmed:
            return .blue
        case .inProduction:
            return .purple
        case .shipped:
            return .teal
        case .delivered:
            return .green
        case .cancelled:
            return .red
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
