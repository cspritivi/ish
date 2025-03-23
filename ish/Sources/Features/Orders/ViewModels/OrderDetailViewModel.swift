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
    @Published var measurementNotFound = false
    
    init(order: Order) {
        self.order = order
//        print("OrderDetailViewModel initialized with measurementsId: \(order.measurementsId)")
        fetchMeasurements()
    }
    
    func fetchMeasurements() {
        guard !order.measurementsId.isEmpty else {
//            print("Error: MeasurementsId is empty")
            measurementNotFound = true
            isLoading = false
            return
        }
        
        isLoading = true
//        print("Fetching measurements with ID: \(order.measurementsId)")
        
        Task {
            do {
                let db = Firestore.firestore()
                let docRef = db.collection("measurements").document(order.measurementsId)
//                print("Requesting document at path: \(docRef.path)")
                
                let snapshot = try await docRef.getDocument()
                
                if snapshot.exists {
//                    print("Document exists, parsing data")
                    let measurements = try Measurements.from(snapshot)
                    
                    await MainActor.run {
//                        print("Measurements loaded successfully: \(measurements.profileName)")
                        self.measurements = measurements
                        self.isLoading = false
                    }
                } else {
//                    print("Document does not exist")
                    await MainActor.run {
                        self.measurementNotFound = true
                        self.isLoading = false
                    }
                }
            } catch {
//                print("Error fetching measurements: \(error.localizedDescription)")
                await MainActor.run {
                    self.errorMessage = "Failed to load measurements: \(error.localizedDescription)"
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
