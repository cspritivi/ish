//
//  OrderReviewViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//

// ish/Sources/Features/Orders/ViewModels/OrderReviewViewModel.swift
import Foundation
import FirebaseAuth

class OrderReviewViewModel: ObservableObject {
    @Published var product: Product
    @Published var fabric: Fabric
    @Published var styleChoices: [String: StyleOptionChoice]
    @Published var availableMeasurements: [Measurements] = []
    @Published var selectedMeasurementId: String?
    @Published var totalPrice: Double = 0.0
    @Published var notes: String = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var orderPlaced = false
    @Published var savedOrderId: String?
    
    init(product: Product, fabric: Fabric, styleChoices: [String: StyleOptionChoice]) {
        self.product = product
        self.fabric = fabric
        self.styleChoices = styleChoices
        calculatePrice()
        fetchMeasurements()
    }
    
    private func calculatePrice() {
        totalPrice = OrderService.shared.calculateTotalPrice(
            product: product,
            fabric: fabric,
            styleChoices: styleChoices
        )
    }
    
    func fetchMeasurements() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showError = true
            errorMessage = "User not logged in"
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let measurements = try await MeasurementService.shared.getMeasurements(for: userId)
                await MainActor.run {
                    self.availableMeasurements = measurements
                    if let firstMeasurement = measurements.first {
                        self.selectedMeasurementId = firstMeasurement.id
                    }
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
    
    func saveAsDraft() {
        createOrder(status: .draft)
    }
    
    func placeOrder() {
        createOrder(status: .pending)
    }
    
    private func createOrder(status: OrderStatus) {
        guard let userId = Auth.auth().currentUser?.uid,
              let measurementId = selectedMeasurementId else {
            showError = true
            errorMessage = "Please select a measurement profile"
            return
        }
        
        isLoading = true
        
        let order = Order(
            userId: userId,
            product: product,
            fabric: fabric,
            styleChoices: styleChoices,
            measurementsId: measurementId,
            totalPrice: totalPrice,
            status: status,
            notes: notes
        )
        
        Task {
            do {
                try await OrderService.shared.saveOrder(order)
                await MainActor.run {
                    self.savedOrderId = order.id
                    self.orderPlaced = true
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
    
    // Helper method to calculate total price from style choices
    func getTotalAdditionalPrice() -> Double {
        var additionalPrice = 0.0
        for (_, choice) in styleChoices {
            additionalPrice += choice.additionalPrice
        }
        return additionalPrice
    }
    
    // Helper method to format currency
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
    
    // Helper method to return a specific measurement profile
    func getMeasurementProfile(by id: String) -> Measurements? {
        return availableMeasurements.first { $0.id == id }
    }
    
    // Helper method to format dates
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Validation method
    func canPlaceOrder() -> Bool {
        return selectedMeasurementId != nil
    }
    
    // Reset method for clearing data
    func reset() {
        selectedMeasurementId = availableMeasurements.first?.id
        notes = ""
        orderPlaced = false
        savedOrderId = nil
    }
}
//
//extension OrderReviewViewModel {
//    func getTotalAdditionalPrice() -> Double {
//        var additionalPrice = 0.0
//        for (_, choice) in styleChoices {
//            additionalPrice += choice.additionalPrice
//        }
//        return additionalPrice
//    }
//}
