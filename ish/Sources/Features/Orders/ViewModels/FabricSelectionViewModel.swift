//
//  FabricSelectionViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/ViewModels/FabricSelectionViewModel.swift
import Foundation
import Combine

class FabricSelectionViewModel: ObservableObject {
    @Published var fabrics: [Fabric] = []
    @Published var filteredFabrics: [Fabric] = []
    @Published var selectedColor: String?
    @Published var selectedPattern: FabricPattern?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    
    private let productCategory: ProductCategory
    private var cancellables = Set<AnyCancellable>()
    
    init(productCategory: ProductCategory) {
        self.productCategory = productCategory
        setupFilters()
    }
    
    private func setupFilters() {
        Publishers.CombineLatest($selectedColor, $selectedPattern)
            .sink { [weak self] color, pattern in
                guard let self = self else { return }
                
                var filtered = self.fabrics
                
                if let color = color {
                    filtered = filtered.filter { $0.color == color }
                }
                
                if let pattern = pattern {
                    filtered = filtered.filter { $0.pattern == pattern }
                }
                
                self.filteredFabrics = filtered
            }
            .store(in: &cancellables)
    }
    
    func fetchFabrics() {
        isLoading = true
        
        Task {
            do {
                let fetchedFabrics = try await FabricService.shared.getFabricsByCategory(category: productCategory)
                await MainActor.run {
                    self.fabrics = fetchedFabrics
                    self.filteredFabrics = fetchedFabrics
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
    
    func getAvailableColors() -> [String] {
        let colors = fabrics.map { $0.color }
        return Array(Set(colors)).sorted()
    }
    
    func getAvailablePatterns() -> [FabricPattern] {
        let patterns = fabrics.map { $0.pattern }
        return Array(Set(patterns)).sorted { $0.rawValue < $1.rawValue }
    }
    
    func clearFilters() {
        selectedColor = nil
        selectedPattern = nil
    }
}
