//
//  ProductService.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//

// ish/Sources/Features/Orders/Services/ProductService.swift
import Foundation
import FirebaseFirestore

class ProductService {
    static let shared = ProductService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getProducts() async throws -> [Product] {
        let snapshot = try await db.collection("products").getDocuments()
        return try snapshot.documents.map { try Product.from($0) }
    }
    
    func getProductsByCategory(category: ProductCategory) async throws -> [Product] {
        let snapshot = try await db.collection("products")
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()
        
        return try snapshot.documents.map { try Product.from($0) }
    }
    
    func getProduct(id: String) async throws -> Product {
        let document = try await db.collection("products").document(id).getDocument()
        return try Product.from(document)
    }
}
