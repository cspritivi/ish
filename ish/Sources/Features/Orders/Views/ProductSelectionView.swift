//
//  ProductSelectionView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/ProductSelectionView.swift
import SwiftUI

struct ProductSelectionView: View {
    @StateObject private var viewModel = ProductSelectionViewModel()
    @Binding var selectedProduct: Product?
    
    var body: some View {
        VStack {
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Button(action: {
                        viewModel.selectedCategory = nil
                    }) {
                        CategoryChipView(
                            title: "All",
                            isSelected: viewModel.selectedCategory == nil
                        )
                    }
                    
                    ForEach(ProductCategory.allCases) { category in
                        Button(action: {
                            viewModel.selectedCategory = category
                        }) {
                            CategoryChipView(
                                title: category.rawValue,
                                isSelected: viewModel.selectedCategory == category
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if viewModel.filteredProducts.isEmpty {
                VStack {
                    Image(systemName: "tshirt")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No products available")
                        .font(.headline)
                    
                    Text("Try selecting a different category")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.filteredProducts) { product in
                            ProductCardView(
                                product: product,
                                isSelected: selectedProduct?.id == product.id
                            )
                            .onTapGesture {
                                selectedProduct = product
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchProducts()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
