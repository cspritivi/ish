//
//  OrderStatus.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/Models/OrderStatus.swift
import Foundation

enum OrderStatus: String, Codable, CaseIterable {
    case draft = "Draft"
    case pending = "Pending"
    case confirmed = "Confirmed"
    case inProduction = "In Production"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
}
