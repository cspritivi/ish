//
//  MeasurementService.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/23/25.
//

// Sources/Features/Measurements/Services/MeasurementService.swift
import FirebaseFirestore

class MeasurementService {
    static let shared = MeasurementService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveMeasurements(_ measurements: Measurements) async throws {
        try await db.collection("measurements")
            .document(measurements.id)
            .setData(measurements.dictionary)
    }
    
    func getMeasurements(for userId: String) async throws -> [Measurements] {
        let snapshot = try await db.collection("measurements")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        return try snapshot.documents.map { try Measurements.from($0) }
    }
}
