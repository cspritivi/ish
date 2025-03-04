//
//  Product.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/Models/Product.swift
import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable {
    var id: String
    let name: String
    let category: ProductCategory
    let basePrice: Double
    let description: String
    let imageURLs: [String]
    
    init(id: String = UUID().uuidString,
         name: String,
         category: ProductCategory,
         basePrice: Double,
         description: String = "",
         imageURLs: [String] = []) {
        self.id = id
        self.name = name
        self.category = category
        self.basePrice = basePrice
        self.description = description
        self.imageURLs = imageURLs
    }
}

// Firestore Extensions

extension Product {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "category": category.rawValue,
            "basePrice": basePrice,
            "description": description,
            "imageURLs": imageURLs
        ]
    }
    
    static func from(_ snapshot: DocumentSnapshot) throws -> Product {
        guard let data = snapshot.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data was empty."])
        }
        
        guard let categoryString = data["category"] as? String,
              let category = ProductCategory(rawValue: categoryString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid product category."])
        }
        
        return Product(
            id: snapshot.documentID,
            name: data["name"] as? String ?? "",
            category: category,
            basePrice: data["basePrice"] as? Double ?? 0.0,
            description: data["description"] as? String ?? "",
            imageURLs: data["imageURLs"] as? [String] ?? []
        )
    }
}
