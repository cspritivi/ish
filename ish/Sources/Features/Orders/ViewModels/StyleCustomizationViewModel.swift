//
//  StyleCustomizationViewModel.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/1/25.
//
// ish/Sources/Features/Orders/ViewModels/StyleCustomizationViewModel.swift
import Foundation
import Combine

class StyleCustomizationViewModel: ObservableObject {
    @Published var styleOptions: [StyleOption] = []
    @Published var selectedChoices: [String: StyleOptionChoice] = [:]
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    
    private let productCategory: ProductCategory
    
    init(productCategory: ProductCategory) {
        self.productCategory = productCategory
    }
    
    func fetchStyleOptions() {
        isLoading = true
        
        Task {
            do {
                let options = try await StyleOptionService.shared.getStyleOptionsForProduct(category: productCategory)
                await MainActor.run {
                    self.styleOptions = options
                    
                    // Set default selections
                    for option in options {
                        if let firstChoice = option.options.first {
                            self.selectedChoices[option.id] = firstChoice
                        }
                    }
                    
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
    
    func selectOption(for styleOptionId: String, choice: StyleOptionChoice) {
        selectedChoices[styleOptionId] = choice
    }
    
    func getTotalAdditionalPrice() -> Double {
        var total = 0.0
        for (_, choice) in selectedChoices {
            total += choice.additionalPrice
        }
        return total
    }
}
