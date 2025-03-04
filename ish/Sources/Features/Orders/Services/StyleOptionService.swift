//
//  StyleOptionService.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//

// ish/Sources/Features/Orders/Services/StyleOptionService.swift
import Foundation
import FirebaseFirestore

class StyleOptionService {
    static let shared = StyleOptionService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func getStyleOptions() async throws -> [StyleOption] {
        let snapshot = try await db.collection("styleOptions").getDocuments()
        return try snapshot.documents.map { try StyleOption.from($0) }
    }
    
    func getStyleOptionsForProduct(category: ProductCategory) async throws -> [StyleOption] {
        let snapshot = try await db.collection("styleOptions")
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()
        
        return try snapshot.documents.map { try StyleOption.from($0) }
    }
    
    func getStyleOption(id: String) async throws -> StyleOption {
        let document = try await db.collection("styleOptions").document(id).getDocument()
        return try StyleOption.from(document)
    }
}
