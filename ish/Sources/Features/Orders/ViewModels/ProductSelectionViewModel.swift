//
//  ProductSelectionViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//

// ish/Sources/Features/Orders/ViewModels/ProductSelectionViewModel.swift
import Foundation
import Combine
import FirebaseAuth

class ProductSelectionViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var selectedCategory: ProductCategory?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupCategoryFilter()
    }
    
    private func setupCategoryFilter() {
        $selectedCategory
            .sink { [weak self] category in
                guard let self = self else { return }
                if let category = category {
                    self.filteredProducts = self.products.filter { $0.category == category }
                } else {
                    self.filteredProducts = self.products
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchProducts() {
        isLoading = true
        
        Task {
            do {
                let fetchedProducts = try await ProductService.shared.getProducts()
                await MainActor.run {
                    self.products = fetchedProducts
                    self.filteredProducts = fetchedProducts
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchProductsByCategory(_ category: ProductCategory) {
        isLoading = true
        
        Task {
            do {
                let fetchedProducts = try await ProductService.shared.getProductsByCategory(category: category)
                await MainActor.run {
                    self.products = fetchedProducts
                    self.filteredProducts = fetchedProducts
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
}
