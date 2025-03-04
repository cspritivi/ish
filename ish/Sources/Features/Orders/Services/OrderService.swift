//
//  OrderService.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/Services/OrderService.swift
import Foundation
import FirebaseFirestore
import FirebaseAuth

class OrderService {
    static let shared = OrderService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveOrder(_ order: Order) async throws {
        try await db.collection("orders")
            .document(order.id)
            .setData(order.dictionary)
    }
    
    func getOrders(for userId: String) async throws -> [Order] {
        let snapshot = try await db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        return try snapshot.documents.map { try Order.from($0) }
    }
    
    func getOrder(id: String) async throws -> Order {
        let document = try await db.collection("orders").document(id).getDocument()
        return try Order.from(document)
    }
    
    func updateOrderStatus(orderId: String, status: OrderStatus) async throws {
        try await db.collection("orders").document(orderId).updateData([
            "status": status.rawValue,
            "updatedAt": Timestamp(date: Date())
        ])
    }
    
    func deleteOrder(id: String) async throws {
        try await db.collection("orders").document(id).delete()
    }
    
    func calculateTotalPrice(product: Product, fabric: Fabric, styleChoices: [String: StyleOptionChoice]) -> Double {
        // Base price * fabric multiplier
        var total = product.basePrice * fabric.priceMultiplier
        
        // Add additional costs from style choices
        for (_, choice) in styleChoices {
            total += choice.additionalPrice
        }
        
        return total
    }
    
    func saveDraftOrder(_ order: Order) async throws {
        var draftOrder = order
        draftOrder.status = .draft
        try await saveOrder(draftOrder)
    }
    
    func submitOrder(orderId: String) async throws {
        try await updateOrderStatus(orderId: orderId, status: .pending)
    }
}
