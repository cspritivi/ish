//
//  ProductCategory.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/25/25.
//

enum MeasurementCategory: String, CaseIterable, Identifiable, Codable {
    case shirt = "Shirt"
    case pant = "Pant"
    case suit = "Suit"
    
    var id : String { self.rawValue }
    
    var measurements: [String] {
        switch self {
        case .pant: return ["Waist", "Hips", "Inseam", "Outseam", "Thigh", "Knee", "Cuff", "Front Rise", "Back Rise"]
        case .shirt: return ["Chest", "Shoulder", "Sleeve Length", "Waist", "Hip", "Shirt Length", "Neck"]
        default: return ["Chest", "Shoulder", "Sleeve Length", "Back Length", "Waist", "Hip", "Neck"]
        }
    }
}
