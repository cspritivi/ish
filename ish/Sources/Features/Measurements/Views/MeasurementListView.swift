//
//  MeasurementListView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/24/25.
//

// Sources/Features/Measurements/Views/MeasurementListView.swift
import SwiftUI

struct MeasurementListView: View {
    @StateObject private var viewModel = MeasurementListViewModel()
    @State private var showAddNew = false
    
    var body: some View {
        // Content view with different states
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading measurements...")
            } else if viewModel.measurements.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "ruler")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No measurement profiles yet")
                        .font(.headline)
                    
                    Text("Add your first measurement profile to start creating custom clothing")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Button(action: { showAddNew = true }) {
                        Text("Add Measurements")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 220)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                List {
                    ForEach(viewModel.measurements) { measurement in
                        NavigationLink(destination: MeasurementDetailView(measurement: measurement)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(measurement.profileName)
                                    .font(.headline)
                                
                                Text("Last updated: \(viewModel.formatDate(measurement.updatedAt))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: viewModel.deleteMeasurement)
                }
            }
        }
        // These modifiers apply to the entire view regardless of state
        .navigationTitle("My Measurements")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddNew = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddNew) {
            MeasurementFormView()
        }
        .onAppear {
            viewModel.fetchMeasurements()
        }
        .refreshable {
            viewModel.fetchMeasurements()
        }
    }
}

#Preview {
    NavigationView {
        MeasurementListView()
    }
}
