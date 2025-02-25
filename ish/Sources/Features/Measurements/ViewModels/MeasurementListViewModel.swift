//
//  MeasurementListViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/24/25.
//

// Sources/Features/Measurements/ViewModels/MeasurementListViewModel.swift
import Foundation
import FirebaseAuth

class MeasurementListViewModel: ObservableObject {
    @Published var measurements: [Measurements] = []
    @Published var isLoading = false
    
    func fetchMeasurements() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let fetchedMeasurements = try await MeasurementService.shared.getMeasurements(for: userId)
                
                await MainActor.run {
                    self.measurements = fetchedMeasurements.sorted { $0.updatedAt > $1.updatedAt }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    print("Error fetching measurements: \(error)")
                }
            }
        }
    }
    
    func deleteMeasurement(at offsets: IndexSet) {
        Task {
            do {
                for index in offsets {
                    let measurement = measurements[index]
                    try await MeasurementService.shared.deleteMeasurement(id: measurement.id)
                }
                
                // Refresh the list
                await MainActor.run {
                    measurements.remove(atOffsets: offsets)
                }
            } catch {
                print("Error deleting measurement: \(error)")
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

