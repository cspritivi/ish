//
//  StyleOptionChoice.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/Models/StyleOptionChoice.swift
import Foundation

struct StyleOptionChoice: Identifiable, Codable {
    var id: String
    let name: String
    let description: String
    let imageURL: String
    let additionalPrice: Double
    
    init(id: String = UUID().uuidString,
         name: String,
         description: String = "",
         imageURL: String = "",
         additionalPrice: Double = 0.0) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.additionalPrice = additionalPrice
    }
}

extension StyleOptionChoice {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "description": description,
            "imageURL": imageURL,
            "additionalPrice": additionalPrice
        ]
    }
}

extension StyleOptionChoice: Equatable {
    static func == (lhs: StyleOptionChoice, rhs: StyleOptionChoice) -> Bool {
        return lhs.id == rhs.id
    }
}
