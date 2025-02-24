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
    let chest: Double
    let waist: Double
    let hips: Double
    let inseam: Double
    let shoulder: Double
    let sleeve: Double
    let neck: Double
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString, userId: String, profileName: String, chest: Double, waist: Double,
         hips: Double, inseam: Double, shoulder: Double, sleeve: Double, neck: Double, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.profileName = profileName
        self.chest = chest
        self.waist = waist
        self.hips = hips
        self.inseam = inseam
        self.shoulder = shoulder
        self.sleeve = sleeve
        self.neck = neck
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Measurements {
    var dictionary: [String: Any] {
        return [
            "id" : id,
            "userId" : userId,
            "profileName" : profileName,
            "chest" : chest,
            "waist" : waist,
            "hips" : hips,
            "inseam" : inseam,
            "shoulder" : shoulder,
            "sleeve" : sleeve,
            "neck" : neck,
            "createdAt" : createdAt,
            "updatedAt" : updatedAt
        ]
    }
    
    static func from(_ snapshot: DocumentSnapshot) throws -> Measurements {
        
        guard let data = snapshot.data() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document data was empty."])
        }
        
        return Measurements(
            id: snapshot.documentID,
            userId: data["userId"] as? String ?? "",
            profileName: data["profileName"] as? String ?? "",
            chest: data["chest"] as? Double ?? 0.0,
            waist: data["waist"] as? Double ?? 0.0,
            hips: data["hips"] as? Double ?? 0.0,
            inseam: data["inseam"] as? Double ?? 0.0,
            shoulder: data["shoulder"] as? Double ?? 0.0,
            sleeve: data["sleeve"] as? Double ?? 0.0,
            neck: data["neck"] as? Double ?? 0.0,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
}
