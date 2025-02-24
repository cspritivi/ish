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
    @Published var chest: Double = 0.0
    @Published var waist: Double = 0.0
    @Published var hips: Double = 0.0
    @Published var inseam: Double = 0.0
    @Published var shoulder: Double = 0.0
    @Published var sleeve: Double = 0.0
    @Published var neck: Double = 0.0
    
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    var isValid: Bool {
        !profileName.isEmpty &&
        chest > 0 && waist > 0 && hips > 0 &&
        inseam > 0 && shoulder > 0 && sleeve > 0 && neck > 0
    }
    
    func saveMeasurements() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showError = true
            errorMessage = "User not logged in"
            return
        }
        
        isLoading = true
        
        let measurements = Measurements(
            userId: userId,
            profileName: profileName,
            chest: chest,
            waist: waist,
            hips: hips,
            inseam: inseam,
            shoulder: shoulder,
            sleeve: sleeve,
            neck: neck
        )
        
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
