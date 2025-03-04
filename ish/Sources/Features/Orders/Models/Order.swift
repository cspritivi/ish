//
//  Order.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/Models/Order.swift
import Foundation
import FirebaseFirestore

struct Order: Identifiable, Codable {
    var id: String
    let userId: String
    let product: Product
    let fabric: Fabric
    let styleChoices: [String: StyleOptionChoice]
    let measurementsId: String
    let totalPrice: Double
//    let status: OrderStatus
    var status: OrderStatus
    let notes: String
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         product: Product,
         fabric: Fabric,
         styleChoices: [String: StyleOptionChoice],
         measurementsId: String,
         totalPrice: Double,
         status: OrderStatus = .draft,
         notes: String = "",
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.product = product
        self.fabric = fabric
        self.styleChoices = styleChoices
        self.measurementsId = measurementsId
        self.totalPrice = totalPrice
        self.status = status
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Order {
    var dictionary: [String: Any] {
        var styleChoicesDict: [String: [String: Any]] = [:]
        styleChoices.forEach { key, choice in
            styleChoicesDict[key] = choice.dictionary
        }
        
        return [
            "id": id,
            "userId": userId,
            "product": product.dictionary,
            "fabric": fabric.dictionary,
            "styleChoices": styleChoicesDict,
            "measurementsId": measurementsId,
            "totalPrice": totalPrice,
            "status": status.rawValue,
            "notes": notes,
            "createdAt": createdAt,
            "updatedAt": updatedAt
        ]
    }
    
    static func from(_ snapshot: DocumentSnapshot) throws -> Order {
        guard let data = snapshot.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data was empty."])
        }
        
        guard let productData = data["product"] as? [String: Any],
              let fabricData = data["fabric"] as? [String: Any],
              let styleChoicesData = data["styleChoices"] as? [String: [String: Any]],
              let statusString = data["status"] as? String,
              let status = OrderStatus(rawValue: statusString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid order data."])
        }
        
        // Process product data
        guard let categoryString = productData["category"] as? String,
              let category = ProductCategory(rawValue: categoryString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid product category."])
        }
        
        let product = Product(
            id: productData["id"] as? String ?? UUID().uuidString,
            name: productData["name"] as? String ?? "",
            category: category,
            basePrice: productData["basePrice"] as? Double ?? 0.0,
            description: productData["description"] as? String ?? "",
            imageURLs: productData["imageURLs"] as? [String] ?? []
        )
        
        // Process fabric data
        guard let fabricCategoryString = fabricData["category"] as? String,
              let fabricCategory = ProductCategory(rawValue: fabricCategoryString),
              let patternString = fabricData["pattern"] as? String,
              let pattern = FabricPattern(rawValue: patternString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid fabric data."])
        }
        
        let fabric = Fabric(
            id: fabricData["id"] as? String ?? UUID().uuidString,
            name: fabricData["name"] as? String ?? "",
            category: fabricCategory,
            color: fabricData["color"] as? String ?? "",
            pattern: pattern,
            material: fabricData["material"] as? String ?? "",
            priceMultiplier: fabricData["priceMultiplier"] as? Double ?? 1.0,
            imageURL: fabricData["imageURL"] as? String ?? "",
            available: fabricData["available"] as? Bool ?? true
        )
        
        // Process style choices
        var styleChoices: [String: StyleOptionChoice] = [:]
        
        for (key, choiceData) in styleChoicesData {
            let choice = StyleOptionChoice(
                id: choiceData["id"] as? String ?? UUID().uuidString,
                name: choiceData["name"] as? String ?? "",
                description: choiceData["description"] as? String ?? "",
                imageURL: choiceData["imageURL"] as? String ?? "",
                additionalPrice: choiceData["additionalPrice"] as? Double ?? 0.0
            )
            styleChoices[key] = choice
        }
        
        return Order(
            id: snapshot.documentID,
            userId: data["userId"] as? String ?? "",
            product: product,
            fabric: fabric,
            styleChoices: styleChoices,
            measurementsId: data["measurementsId"] as? String ?? "",
            totalPrice: data["totalPrice"] as? Double ?? 0.0,
            status: status,
            notes: data["notes"] as? String ?? "",
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
}
