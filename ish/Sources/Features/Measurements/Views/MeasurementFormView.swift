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
                
                Section(header: Text("Measurements (inches)")) {
                    HStack {
                        Text("Chest")
                        Spacer()
                        TextField("", value: $viewModel.chest, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Waist")
                        Spacer()
                        TextField("", value: $viewModel.waist, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Hips")
                        Spacer()
                        TextField("", value: $viewModel.hips, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Inseam")
                        Spacer()
                        TextField("", value: $viewModel.inseam, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Shoulder")
                        Spacer()
                        TextField("", value: $viewModel.shoulder, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Sleeve")
                        Spacer()
                        TextField("", value: $viewModel.sleeve, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Neck")
                        Spacer()
                        TextField("", value: $viewModel.neck, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Button(action: viewModel.saveMeasurements) {
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
