//
//  FabricPattern.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/Models/FabricPattern.swift
import Foundation

enum FabricPattern: String, Codable, CaseIterable, Identifiable {
    case solid = "Solid"
    case striped = "Striped"
    case checked = "Checked"
    case herringbone = "Herringbone"
    case plaid = "Plaid"
    case pinStripe = "Pin Stripe"
    case houndstooth = "Houndstooth"
    
    var id: String { self.rawValue }
}

