//
//  StyleCustomizationView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/Views/StyleCustomizationView.swift
import SwiftUI

struct StyleCustomizationView: View {
    @StateObject private var viewModel: StyleCustomizationViewModel
    @Binding var styleChoices: [String: StyleOptionChoice]
    
    init(productCategory: ProductCategory, styleChoices: Binding<[String: StyleOptionChoice]>) {
        _viewModel = StateObject(wrappedValue: StyleCustomizationViewModel(productCategory: productCategory))
        _styleChoices = styleChoices
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if viewModel.styleOptions.isEmpty {
                VStack {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No customization options available")
                        .font(.headline)
                }
                .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.styleOptions) { option in
                            StyleOptionSectionView(
                                styleOption: option,
                                selectedChoice: viewModel.selectedChoices[option.id],
                                onSelect: { choice in
                                    viewModel.selectOption(for: option.id, choice: choice)
                                    styleChoices = viewModel.selectedChoices
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchStyleOptions()
            if !styleChoices.isEmpty {
                viewModel.selectedChoices = styleChoices
            }
        }
        .onChange(of: viewModel.selectedChoices) { _ in
            styleChoices = viewModel.selectedChoices
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

