//
//  FabricSelectionView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/FabricSelectionView.swift
import SwiftUI
//import CachedAsyncImage

struct FabricSelectionView: View {
    @StateObject private var viewModel: FabricSelectionViewModel
    @Binding var selectedFabric: Fabric?
    
    init(productCategory: ProductCategory, selectedFabric: Binding<Fabric?>) {
        _viewModel = StateObject(wrappedValue: FabricSelectionViewModel(productCategory: productCategory))
        _selectedFabric = selectedFabric
    }
    
    var body: some View {
        VStack {
            // Filters
            HStack {
                Menu {
                    Button("All Colors") {
                        viewModel.selectedColor = nil
                    }
                    
                    ForEach(viewModel.getAvailableColors(), id: \.self) { color in
                        Button(color) {
                            viewModel.selectedColor = color
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedColor ?? "Color")
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Menu {
                    Button("All Patterns") {
                        viewModel.selectedPattern = nil
                    }
                    
                    ForEach(viewModel.getAvailablePatterns()) { pattern in
                        Button(pattern.rawValue) {
                            viewModel.selectedPattern = pattern
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedPattern?.rawValue ?? "Pattern")
                        Image(systemName: "chevron.down")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.clearFilters()
                }) {
                    Text("Clear")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if viewModel.filteredFabrics.isEmpty {
                VStack {
                    Image(systemName: "swift")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No fabrics found")
                        .font(.headline)
                    
                    Text("Try changing your filters")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.filteredFabrics) { fabric in
                            FabricCardView(
                                fabric: fabric,
                                isSelected: selectedFabric?.id == fabric.id
                            )
                            .onTapGesture {
                                selectedFabric = fabric
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchFabrics()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
