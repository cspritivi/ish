//
//  OrderDetailView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/Views/OrderDetailView.swift
import SwiftUI
//import CachedAsyncImage

struct OrderDetailView: View {
    @StateObject private var viewModel: OrderDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(order: Order) {
        _viewModel = StateObject(wrappedValue: OrderDetailViewModel(order: order))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                StatusSection(status: viewModel.order.status)
                OrderInfoSection(order: viewModel.order)
                ProductSection(product: viewModel.order.product)
                FabricSection(fabric: viewModel.order.fabric)
                StyleCustomizationsSection(styleChoices: viewModel.order.styleChoices)
                MeasurementsSection(viewModel: viewModel)
                PriceSummarySection(totalPrice: viewModel.order.totalPrice)
                // Cancel button for pending orders
                if viewModel.order.status == .pending || viewModel.order.status == .draft {
                    CancelButtonView(viewModel: viewModel)
                }
            }
            .padding()
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .confirmationDialog(
            "Are you sure?",
            isPresented: $viewModel.showConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button("Yes, cancel this order", role: .destructive) {
                viewModel.cancelOrder()
            }
            Button("No, keep it", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Success", isPresented: $viewModel.showSuccessMessage) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Your order has been cancelled successfully.")
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// Helper subviews
struct StatusSection: View {
    
    let status: OrderStatus
    
    var body: some View {
        HStack {
            Text("Order Status")
                .font(.headline)
            
            Spacer()
            
            StatusBadgeView(status: status)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct OrderInfoSection: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Information")
                .font(.headline)
            
            Divider()
            
            LabeledContent("Order ID", value: order.id)
                .font(.subheadline)
            
            LabeledContent("Created", value: formatDate(order.createdAt))
                .font(.subheadline)
            
            LabeledContent("Last Updated", value: formatDate(order.updatedAt))
                .font(.subheadline)
            
            if !order.notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Special Instructions")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(order.notes)
                        .font(.subheadline)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ProductSection: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Product")
                .font(.headline)
            
            Divider()
            
            HStack(alignment: .top, spacing: 12) {
                if let firstImageURL = product.imageURLs.first,
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
                    Text(product.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(product.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if !product.description.isEmpty {
                        Text(product.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        
    }
}


struct FabricSection: View {
    let fabric: Fabric
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Fabric")
                .font(.headline)
            
            Divider()
            
            HStack(alignment: .top, spacing: 12) {
                if let url = URL(string: fabric.imageURL) {
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
                    Text(fabric.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text(fabric.color)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                        
                        Text(fabric.pattern.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Text(fabric.material)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        
    }
}

struct StyleCustomizationsSection : View {
    let styleChoices: [String: StyleOptionChoice]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Style Customizations")
                .font(.headline)
            
            Divider()
            
            if styleChoices.isEmpty {
                Text("No customizations selected")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            } else {
                ForEach(Array(styleChoices.keys.sorted()), id: \.self) { key in
                    if let choice = styleChoices[key] {
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
                        
                        if key != Array(styleChoices.keys.sorted()).last {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        
        
    }
}

//struct MeasurementsSection : View {
//    let viewModel: OrderDetailViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Measurements")
//                .font(.headline)
//            
//            Divider()
//            
//            if viewModel.isLoading {
//                ProgressView()
//                    .padding()
//            } else if let measurements = viewModel.measurements {
//                VStack(alignment: .leading, spacing: 8) {
//                    LabeledContent("Profile", value: measurements.profileName)
//                        .font(.subheadline)
//                    
//                    Divider()
//                    
//                    LabeledContent("Chest", value: String(format: "%.1f in", measurements.chest))
//                        .font(.subheadline)
//                    
//                    LabeledContent("Waist", value: String(format: "%.1f in", measurements.waist))
//                        .font(.subheadline)
//                    
//                    LabeledContent("Hips", value: String(format: "%.1f in", measurements.hips))
//                        .font(.subheadline)
//                    
//                    LabeledContent("Inseam", value: String(format: "%.1f in", measurements.inseam))
//                        .font(.subheadline)
//                    
//                    LabeledContent("Shoulder", value: String(format: "%.1f in", measurements.shoulder))
//                        .font(.subheadline)
//                    
//                    LabeledContent("Sleeve", value: String(format: "%.1f in", measurements.sleeve))
//                        .font(.subheadline)
//                    
//                    LabeledContent("Neck", value: String(format: "%.1f in", measurements.neck))
//                        .font(.subheadline)
//                }
//            } else {
//                Text("Measurement profile not found")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.vertical, 8)
//            }
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//        
//    }
//}

struct MeasurementsSection: View {
    @ObservedObject var viewModel: OrderDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Measurements")
                .font(.headline)
            
            Divider()
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView("Loading measurements...")
                    Spacer()
                }
                .padding(.vertical, 20)
            } else if let measurements = viewModel.measurements {
                VStack(alignment: .leading, spacing: 8) {
                    LabeledContent("Profile", value: measurements.profileName)
                        .font(.subheadline)
                    
                    Divider()
                    
                    LabeledContent("Waist", value: String(format: "%.1f", measurements.waist ?? -1)).font(.subheadline)
                    
                    if measurements.measurementCategory == .shirt || measurements.measurementCategory == .suit {
                        LabeledContent("Chest", value: String(format: "%.1f", measurements.chest ?? -1)).font(.subheadline)
                        LabeledContent("Shoulder", value: String(format: "%.1f", measurements.shoulder ?? -1)).font(.subheadline)
                        LabeledContent("Sleeve", value: String(format: "%.1f", measurements.sleeve ?? -1)).font(.subheadline)
                        LabeledContent("Hips", value: String(format: "%.1f", measurements.hips ?? -1)).font(.subheadline)
                        LabeledContent("Neck", value: String(format: "%.1f", measurements.neck ?? -1)).font(.subheadline)
                    }
                    
                    if measurements.measurementCategory == .suit {
                        LabeledContent("Back", value: String(format: "%.1f", measurements.back ?? -1)).font(.subheadline)
                    }
                    
                    if measurements.measurementCategory == .shirt {
                        LabeledContent("Shirt Length", value: String(format: "%.1f", measurements.shirtLength ?? -1)).font(.subheadline)
                    }
                    
                    if measurements.measurementCategory == .pant {
                        LabeledContent("Inseam", value: String(format: "%.1f", measurements.inseam ?? -1)).font(.subheadline)
                        LabeledContent("Outseam", value: String(format: "%.1f", measurements.outseam ?? -1)).font(.subheadline)
                        LabeledContent("Thigh", value: String(format: "%.1f", measurements.thigh ?? -1)).font(.subheadline)
                        LabeledContent("Knee", value: String(format: "%.1f", measurements.knee ?? -1)).font(.subheadline)
                        LabeledContent("Cuff", value: String(format: "%.1f", measurements.cuff ?? -1)).font(.subheadline)
                        LabeledContent("Front Rise", value: String(format: "%.1f", measurements.frontRise ?? -1)).font(.subheadline)
                        LabeledContent("Back Rise", value: String(format: "%.1f", measurements.backRise ?? -1)).font(.subheadline)
                    }
                }
            } else if viewModel.measurementNotFound {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                        .padding(.bottom, 4)
                    
                    Text("Measurement profile not found")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Measurement ID: \(viewModel.order.measurementsId)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            } else {
                Text("Could not load measurement information")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct PriceSummarySection: View {
    let totalPrice: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price Summary")
                .font(.headline)
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("$\(totalPrice, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct CancelButtonView: View {
    let viewModel: OrderDetailViewModel
    
    var body: some View {
        Button(action: {
            viewModel.showConfirmationDialog = true
        }) {
            Text(viewModel.order.status == .draft ? "Delete Draft" : "Cancel Order")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let product = Product(
        name: "Classic Oxford Shirt",
        category: .shirt,
        basePrice: 89.99,
        description: "A timeless classic shirt suitable for any occasion."
    )
    
    let fabric = Fabric(
        name: "Premium Cotton",
        category: .shirt,
        color: "White",
        pattern: .solid,
        material: "100% Egyptian Cotton",
        priceMultiplier: 1.2
    )
    
    let styleChoices: [String: StyleOptionChoice] = [
        "Collar": StyleOptionChoice(
            name: "Spread Collar",
            description: "A classic spread collar",
            additionalPrice: 0.0
        ),
        "Cuff": StyleOptionChoice(
            name: "Button Cuff",
            description: "Traditional button cuff",
            additionalPrice: 0.0
        )
    ]
    
    let order = Order(
        userId: "test-user",
        product: product,
        fabric: fabric,
        styleChoices: styleChoices,
        measurementsId: "test-measurement",
        totalPrice: 107.99,
        status: .pending,
        notes: "Please add extra buttons."
    )
    
    return NavigationView {
        OrderDetailView(order: order)
    }
}
