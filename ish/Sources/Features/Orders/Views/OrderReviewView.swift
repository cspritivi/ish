//
//  OrderReviewView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/Views/OrderReviewView.swift
import SwiftUI
//import CachedAsyncImage

struct OrderReviewView: View {
    @StateObject private var viewModel: OrderReviewViewModel
    let onOrderPlaced: (String) -> Void
    
    init(product: Product, fabric: Fabric, styleChoices: [String: StyleOptionChoice], onOrderPlaced: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: OrderReviewViewModel(
            product: product,
            fabric: fabric,
            styleChoices: styleChoices
        ))
        self.onOrderPlaced = onOrderPlaced
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Product section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Product")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 12) {
                        if let firstImageURL = viewModel.product.imageURLs.first,
                           let url = URL(string: firstImageURL) {
                            CachedAsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                        .frame(width: 80, height: 80)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "tshirt")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.product.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(viewModel.product.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("Base Price: $\(viewModel.product.basePrice, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Fabric section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Fabric")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 12) {
                        if let url = URL(string: viewModel.fabric.imageURL) {
                            CachedAsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                        .frame(width: 80, height: 80)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "swift")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.fabric.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Text(viewModel.fabric.color)
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                                
                                Text(viewModel.fabric.pattern.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                            }
                            
                            Text("\(viewModel.fabric.material) • Price Multiplier: \(viewModel.fabric.priceMultiplier, specifier: "%.2f")x")
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Style choices section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Style Customizations")
                        .font(.headline)
                    
                    if viewModel.styleChoices.isEmpty {
                        Text("No customizations selected")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(Array(viewModel.styleChoices.keys.sorted()), id: \.self) { key in
                            if let choice = viewModel.styleChoices[key] {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(key)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        
                                        Text(choice.name)
                                            .font(.body)
                                    }
                                    
                                    Spacer()
                                    
                                    if choice.additionalPrice > 0 {
                                        Text("+$\(choice.additionalPrice, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 4)
                                
                                Divider()
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Measurements section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Measurements")
                        .font(.headline)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else if viewModel.availableMeasurements.isEmpty {
                        VStack(spacing: 8) {
                            Text("No measurement profiles found")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            NavigationLink(destination: MeasurementFormView()) {
                                Text("Create New Measurement Profile")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    } else {
                        Picker("Select Measurement Profile", selection: $viewModel.selectedMeasurementId) {
                            ForEach(viewModel.availableMeasurements) { measurement in
                                Text(measurement.profileName).tag(Optional(measurement.id))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.vertical, 8)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Notes section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Special Instructions (Optional)")
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 100)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Price summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Price Summary")
                        .font(.headline)
                    
                    HStack {
                        Text("Base Price")
                        Spacer()
                        Text("$\(viewModel.product.basePrice, specifier: "%.2f")")
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Text("Fabric Adjustment")
                        Spacer()
                        Text("\(viewModel.fabric.priceMultiplier, specifier: "%.2f")x")
                    }
                    .font(.subheadline)
                    
                    if viewModel.getTotalAdditionalPrice() > 0 {
                        HStack {
                            Text("Style Customizations")
                            Spacer()
                            Text("+$\(viewModel.getTotalAdditionalPrice(), specifier: "%.2f")")
                        }
                        .font(.subheadline)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.placeOrder()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Place Order")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .disabled(viewModel.selectedMeasurementId == nil || viewModel.isLoading)
                    
                    Button(action: {
                        viewModel.saveAsDraft()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Save as Draft")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .disabled(viewModel.selectedMeasurementId == nil || viewModel.isLoading)
                }
            }
            .padding()
        }
        .onChange(of: viewModel.orderPlaced) { was, placed in
            if placed, let orderId = viewModel.savedOrderId {
                onOrderPlaced(orderId)
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        
    }
}
