//
//  ProductCategory.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/Models/ProductCategory.swift
import Foundation

enum ProductCategory: String, Codable, CaseIterable, Identifiable {
    case suit = "Suit"
    case shirt = "Shirt"
    case trousers = "Trousers"
    case blazer = "Blazer"
    case waistcoat = "Waistcoat"
    case accessories = "Accessories"
    
    var id: String { self.rawValue }
}
