//
//  MeasurementDetailView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/24/25.
//

// Sources/Features/Measurements/Views/MeasurementDetailView.swift
import SwiftUI

struct MeasurementDetailView: View {
    let measurement: Measurements
    
    var body: some View {
        List {
            Section(header: Text("Profile Details")) {
                LabeledContent("Profile Name", value: measurement.profileName)
                LabeledContent("Created", value: formatDate(measurement.createdAt))
                LabeledContent("Last Updated", value: formatDate(measurement.updatedAt))
            }
            
            Section(header: Text("Measurements (inches)")) {
                LabeledContent("Chest", value: String(format: "%.1f", measurement.chest))
                LabeledContent("Waist", value: String(format: "%.1f", measurement.waist))
                LabeledContent("Hips", value: String(format: "%.1f", measurement.hips))
                LabeledContent("Inseam", value: String(format: "%.1f", measurement.inseam))
                LabeledContent("Shoulder", value: String(format: "%.1f", measurement.shoulder))
                LabeledContent("Sleeve", value: String(format: "%.1f", measurement.sleeve))
                LabeledContent("Neck", value: String(format: "%.1f", measurement.neck))
            }
        }
        .navigationTitle(measurement.profileName)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

