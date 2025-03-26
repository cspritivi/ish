//
//  MeasurementFormView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/23/25.
//

// Sources/Features/Measurements/Views/MeasurementFormView.swift
import SwiftUI

struct MeasurementFormView: View {
    @StateObject private var viewModel = MeasurementFormViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Details")) {
                    TextField("Profile Name (e.g., Formal Wear)", text: $viewModel.profileName)
                }
                
                Picker("Garment Type", selection: $viewModel.measurementCategory) {
                    ForEach(MeasurementCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                
                Section(header: Text("Measurements (inches)")) {
                    
                    MeasurementFormItemView(title: "Waist", value: $viewModel.waist)
                    
                    if viewModel.measurementCategory == .suit {
                        MeasurementFormItemView(title: "Back", value: $viewModel.back)
                    }
                    
                    if viewModel.measurementCategory == .suit || viewModel.measurementCategory == .shirt {
                        MeasurementFormItemView(title: "Chest", value: $viewModel.chest)
                        MeasurementFormItemView(title: "Shoulder", value: $viewModel.shoulder)
                        MeasurementFormItemView(title: "Sleeve", value: $viewModel.sleeve)
                        MeasurementFormItemView(title: "Hips", value: $viewModel.hips)
                        MeasurementFormItemView(title: "Neck", value: $viewModel.neck)
                    }
                    
                    if viewModel.measurementCategory == .shirt {
                        MeasurementFormItemView(title: "Shirt Length", value: $viewModel.shirtLength)
                    }
                    
                    if viewModel.measurementCategory == .pant {
                        MeasurementFormItemView(title: "Inseam", value: $viewModel.inseam)
                        MeasurementFormItemView(title: "Outseam", value: $viewModel.outseam)
                        MeasurementFormItemView(title: "Thigh", value: $viewModel.thigh)
                        MeasurementFormItemView(title: "Knee", value: $viewModel.knee)
                        MeasurementFormItemView(title: "Cuff", value: $viewModel.cuff)
                        MeasurementFormItemView(title: "Front Rise", value: $viewModel.frontRise)
                        MeasurementFormItemView(title: "Back Rise", value: $viewModel.backRise)
                    }
                }
                
                Button(action: {
                    viewModel.saveMeasurements()
                    dismiss()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Save Profile")
                    }
                }
                .disabled(!viewModel.isValid || viewModel.isLoading)
            }
            .navigationTitle("New Measurement Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    MeasurementFormView()
}
