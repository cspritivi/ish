//
//  StyleOption.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//

// ish/Sources/Features/Orders/Models/StyleOption.swift
import Foundation
import FirebaseFirestore

struct StyleOption: Identifiable, Codable {
    var id: String
    let category: ProductCategory
    let type: StyleOptionType
    let name: String
    let options: [StyleOptionChoice]
    
    init(id: String = UUID().uuidString,
         category: ProductCategory,
         type: StyleOptionType,
         name: String,
         options: [StyleOptionChoice]) {
        self.id = id
        self.category = category
        self.type = type
        self.name = name
        self.options = options
    }
}

extension StyleOption {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "category": category.rawValue,
            "type": type.rawValue,
            "name": name,
            "options": options.map { $0.dictionary }
        ]
    }
    
    static func from(_ snapshot: DocumentSnapshot) throws -> StyleOption {
        guard let data = snapshot.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data was empty."])
        }
        
        guard let categoryString = data["category"] as? String,
              let category = ProductCategory(rawValue: categoryString),
              let typeString = data["type"] as? String,
              let type = StyleOptionType(rawValue: typeString),
              let optionsData = data["options"] as? [[String: Any]] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid style option data."])
        }
        
        let options = optionsData.compactMap { optionData -> StyleOptionChoice? in
            guard let id = optionData["id"] as? String,
                  let name = optionData["name"] as? String else {
                return nil
            }
            
            return StyleOptionChoice(
                id: id,
                name: name,
                description: optionData["description"] as? String ?? "",
                imageURL: optionData["imageURL"] as? String ?? "",
                additionalPrice: optionData["additionalPrice"] as? Double ?? 0.0
            )
        }
        
        return StyleOption(
            id: snapshot.documentID,
            category: category,
            type: type,
            name: data["name"] as? String ?? "",
            options: options
        )
    }
}
