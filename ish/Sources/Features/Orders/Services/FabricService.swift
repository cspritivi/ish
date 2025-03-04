//
//  FabricService.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//

// ish/Sources/Features/Orders/Services/FabricService.swift
import Foundation
import FirebaseFirestore

class FabricService {
    static let shared = FabricService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getFabrics() async throws -> [Fabric] {
        let snapshot = try await db.collection("fabrics")
            .whereField("available", isEqualTo: true)
            .getDocuments()
        
        return try snapshot.documents.map { try Fabric.from($0) }
    }
    
    func getFabricsByCategory(category: ProductCategory) async throws -> [Fabric] {
        let snapshot = try await db.collection("fabrics")
            .whereField("category", isEqualTo: category.rawValue)
            .whereField("available", isEqualTo: true)
            .getDocuments()
        
        return try snapshot.documents.map { try Fabric.from($0) }
    }
    
    func getFabric(id: String) async throws -> Fabric {
        let document = try await db.collection("fabrics").document(id).getDocument()
        return try Fabric.from(document)
    }
    
    // Additional filter methods
    func getFabricsByPattern(pattern: FabricPattern) async throws -> [Fabric] {
        let snapshot = try await db.collection("fabrics")
            .whereField("pattern", isEqualTo: pattern.rawValue)
            .whereField("available", isEqualTo: true)
            .getDocuments()
        
        return try snapshot.documents.map { try Fabric.from($0) }
    }
    
    func getFabricsByColor(color: String) async throws -> [Fabric] {
        let snapshot = try await db.collection("fabrics")
            .whereField("color", isEqualTo: color)
            .whereField("available", isEqualTo: true)
            .getDocuments()
        
        return try snapshot.documents.map { try Fabric.from($0) }
    }
}

