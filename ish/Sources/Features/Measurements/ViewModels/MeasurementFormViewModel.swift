//
//  MeasurementFormViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/23/25.
//

// Sources/Features/Measurements/ViewModels/MeasurementFormViewModel.swift
import Foundation
import FirebaseAuth

class MeasurementFormViewModel: ObservableObject {
    @Published var profileName = ""
    @Published var measurementCategory: MeasurementCategory = .suit
    
    // For Suit and Shirt
    @Published var chest: Double?
    @Published var shoulder: Double?
    @Published var sleeve: Double?
    @Published var hips: Double?
    @Published var neck: Double?
    
    // For Suit
    @Published var back: Double?
    
    // For Suit, Shirt, and Pant
    @Published var waist: Double?

    // For Shirt
    @Published var shirtLength: Double?
    
    // For Pant
    @Published var inseam: Double?
    @Published var outseam: Double?
    @Published var thigh: Double?
    @Published var knee: Double?
    @Published var cuff: Double?
    @Published var frontRise: Double?
    @Published var backRise: Double?
    
//    @Published var chest: Double = 0.0
//    @Published var waist: Double = 0.0
//    @Published var hips: Double = 0.0
//    @Published var inseam: Double = 0.0
//    @Published var shoulder: Double = 0.0
//    @Published var sleeve: Double = 0.0
//    @Published var neck: Double = 0.0
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    var isValid: Bool {
        !profileName.isEmpty
        // TASK: insert form validity based on type of measurment and corresponding acceptable value ranges
    }
    
    func saveMeasurements() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showError = true
            errorMessage = "User not logged in"
            return
        }
        
        isLoading = true
        
        let measurements = Measurements(userId: userId, profileName: profileName, measurementCatergory: measurementCategory, chest: chest, shoulder: shoulder, sleeve: sleeve, hips: hips, neck: neck, back: back, waist: waist, shirtLength: shirtLength, inseam: inseam, outseam: outseam, thigh: thigh, knee: knee, cuff: cuff, frontRise: frontRise, backRise: backRise)
        
        Task {
            do {
                try await MeasurementService.shared.saveMeasurements(measurements)
                await MainActor.run {
                    isLoading = false
                    // Handle successful save (e.g., dismiss view)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    showError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
