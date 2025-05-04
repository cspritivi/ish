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
                LabeledContent("Garment Type", value: measurement.measurementCategory.rawValue)
                LabeledContent("Created", value: formatDate(measurement.createdAt))
                LabeledContent("Last Updated", value: formatDate(measurement.updatedAt))
            }
            
            Section(header: Text("Measurements (inches)")) {
                
                LabeledContent("Waist", value: String(format: "%.1f", measurement.waist ?? -1))
                LabeledContent("Hips", value: String(format: "%.1f", measurement.hips ?? -1))
                
                if measurement.measurementCategory == .shirt || measurement.measurementCategory == .suit {
                    LabeledContent("Chest", value: String(format: "%.1f", measurement.chest ?? -1))
                    LabeledContent("Shoulder", value: String(format: "%.1f", measurement.shoulder ?? -1))
                    LabeledContent("Sleeve", value: String(format: "%.1f", measurement.sleeve ?? -1))
                    LabeledContent("Neck", value: String(format: "%.1f", measurement.neck ?? -1))
                }
                
                if measurement.measurementCategory == .suit {
                    LabeledContent("Back", value: String(format: "%.1f", measurement.back ?? -1))
                }
                
                if measurement.measurementCategory == .shirt {
                    LabeledContent("Shirt Length", value: String(format: "%.1f", measurement.shirtLength ?? -1))
                }
                
                if measurement.measurementCategory == .pant {
                    LabeledContent("Inseam", value: String(format: "%.1f", measurement.inseam ?? -1))
                    LabeledContent("Outseam", value: String(format: "%.1f", measurement.outseam ?? -1))
                    LabeledContent("Thigh", value: String(format: "%.1f", measurement.thigh ?? -1))
                    LabeledContent("Knee", value: String(format: "%.1f", measurement.knee ?? -1))
                    LabeledContent("Cuff", value: String(format: "%.1f", measurement.cuff ?? -1))
                    LabeledContent("Front Rise", value: String(format: "%.1f", measurement.frontRise ?? -1))
                    LabeledContent("Back Rise", value: String(format: "%.1f", measurement.backRise ?? -1))
                }
                
                
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

