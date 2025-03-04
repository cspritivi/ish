//
//  Fabric.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//

// ish/Sources/Features/Orders/Models/Fabric.swift
import Foundation
import FirebaseFirestore

struct Fabric: Identifiable, Codable {
    var id: String
    let name: String
    let category: ProductCategory
    let color: String
    let pattern: FabricPattern
    let material: String
    let priceMultiplier: Double
    let imageURL: String
    let available: Bool
    
    init(id: String = UUID().uuidString,
         name: String,
         category: ProductCategory,
         color: String,
         pattern: FabricPattern,
         material: String,
         priceMultiplier: Double = 1.0,
         imageURL: String = "",
         available: Bool = true) {
        self.id = id
        self.name = name
        self.category = category
        self.color = color
        self.pattern = pattern
        self.material = material
        self.priceMultiplier = priceMultiplier
        self.imageURL = imageURL
        self.available = available
    }
}

extension Fabric {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "category": category.rawValue,
            "color": color,
            "pattern": pattern.rawValue,
            "material": material,
            "priceMultiplier": priceMultiplier,
            "imageURL": imageURL,
            "available": available
        ]
    }
    
    static func from(_ snapshot: DocumentSnapshot) throws -> Fabric {
        guard let data = snapshot.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data was empty."])
        }
        
        guard let categoryString = data["category"] as? String,
              let category = ProductCategory(rawValue: categoryString),
              let patternString = data["pattern"] as? String,
              let pattern = FabricPattern(rawValue: patternString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid fabric data."])
        }
        
        return Fabric(
            id: snapshot.documentID,
            name: data["name"] as? String ?? "",
            category: category,
            color: data["color"] as? String ?? "",
            pattern: pattern,
            material: data["material"] as? String ?? "",
            priceMultiplier: data["priceMultiplier"] as? Double ?? 1.0,
            imageURL: data["imageURL"] as? String ?? "",
            available: data["available"] as? Bool ?? true
        )
    }
}
