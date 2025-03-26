//
//  Measurement.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/23/25.
//

import Foundation
import FirebaseFirestore

struct Measurements: Codable, Identifiable {
    var id: String
    let userId: String
    let profileName: String
    var measurementCategory: MeasurementCategory
    
    // For Suit and Shirt
    let chest: Double?
    let shoulder: Double?
    let sleeve: Double?
    let hips: Double?
    let neck: Double?
    
    // For Suit
    let back: Double?
    
    // For Suit, Shirt, and Pant
    let waist: Double?

    // For Shirt
    let shirtLength: Double?
    
    // For Pant
    let inseam: Double?
    let outseam: Double?
    let thigh: Double?
    let knee: Double?
    let cuff: Double?
    let frontRise: Double?
    let backRise: Double?

    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString, userId: String, profileName: String, measurementCatergory: MeasurementCategory, chest: Double?, shoulder: Double?, sleeve: Double?, hips: Double?, neck: Double?, back: Double?, waist: Double?, shirtLength: Double?, inseam: Double?, outseam: Double?, thigh: Double?, knee: Double?, cuff: Double?, frontRise: Double?, backRise: Double?, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.profileName = profileName
        self.measurementCategory = measurementCatergory
        self.chest = chest
        self.shoulder = shoulder
        self.sleeve = sleeve
        self.hips = hips
        self.neck = neck
        self.back = back
        self.waist = waist
        self.shirtLength = shirtLength
        self.inseam = inseam
        self.outseam = outseam
        self.thigh = thigh
        self.knee = knee
        self.cuff = cuff
        self.frontRise = frontRise
        self.backRise = backRise
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Measurements {
    var dictionary: [String: Any] {
        switch measurementCategory {
        case .pant:
            return [
                "id" : id,
                "userId" : userId,
                "profileName" : profileName,
                "waist" : waist!,
                "hips" : hips!,
                "inseam" : inseam!,
                "outseam" : outseam!,
                "thigh" : thigh!,
                "knee" : knee!,
                "createdAt" : createdAt,
                "updatedAt" : updatedAt
            ]
        case .shirt:
            return [
                "id" : id,
                "userId" : userId,
                "profileName" : profileName,
                "chest" : chest!,
                "shoulder" : shoulder!,
                "sleeve" : sleeve!,
                "waist" : waist!,
                "hips" : hips!,
                "shirtLength" : shirtLength!,
                "neck" : neck!,
                "createdAt" : createdAt,
                "updatedAt" : updatedAt
            ]
        default:
            return [
                "id" : id,
                "userId" : userId,
                "profileName" : profileName,
                "chest" : chest!,
                "shoulder" : shoulder!,
                "sleeve" : sleeve!,
                "waist" : waist!,
                "hips" : hips!,
                "back" : back!,
                "neck" : neck!,
                "createdAt" : createdAt,
                "updatedAt" : updatedAt
            ]
        }
    }
    
    static func from(_ snapshot: DocumentSnapshot) throws -> Measurements {
        
        guard let data = snapshot.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data was empty."])
        }
        
        return Measurements(
            id: snapshot.documentID,
            userId: data["userId"] as? String ?? "",
            profileName: data["profileName"] as? String ?? "",
            measurementCatergory: MeasurementCategory(rawValue: data["measurementCategory"] as? String ?? "suit") ?? MeasurementCategory.suit,
            chest: data["chest"] as? Double,
            shoulder: data["shoulder"] as? Double,
            sleeve: data["sleeve"] as? Double,
            hips: data["hips"] as? Double,
            neck: data["neck"] as? Double,
            back: data["back"] as? Double,
            waist: data["waist"] as? Double,
            shirtLength: data["shirtLength"] as? Double,
            inseam: data["inseam"] as? Double,
            outseam: data["outseam"] as? Double,
            thigh: data["thigh"] as? Double,
            knee: data["knee"] as? Double,
            cuff: data["cuff"] as? Double,
            frontRise: data["frontRise"] as? Double,
            backRise: data["backRise"] as? Double,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
}
