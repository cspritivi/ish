//
//  OrderCreationView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/OrderCreationView.swift
import SwiftUI

struct OrderCreationView: View {
    @StateObject private var coordinator = OrderCreationCoordinator()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress bar
                ProgressView(value: coordinator.progress)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Step indicators
                HStack {
                    ForEach(OrderCreationStep.allCases, id: \.rawValue) { step in
                        StepIndicatorView(
                            step: step,
                            currentStep: coordinator.currentStep
                        )
                        
                        if step != .orderReview {
                            Spacer()
                        }
                    }
                }
                .padding()
                
                // Current view
                switch coordinator.currentStep {
                case .productSelection:
                    ProductSelectionView(
                        selectedProduct: $coordinator.selectedProduct
                    )
                    
                case .fabricSelection:
                    if let product = coordinator.selectedProduct {
                        FabricSelectionView(
                            productCategory: product.category,
                            selectedFabric: $coordinator.selectedFabric
                        )
                    } else {
                        Text("Please select a product first")
                            .foregroundColor(.red)
                    }
                    
                case .styleCustomization:
                    if let product = coordinator.selectedProduct {
                        StyleCustomizationView(
                            productCategory: product.category,
                            styleChoices: $coordinator.selectedStyleChoices
                        )
                    } else {
                        Text("Please select a product and fabric first")
                            .foregroundColor(.red)
                    }
                    
                case .orderReview:
                    if let product = coordinator.selectedProduct,
                       let fabric = coordinator.selectedFabric {
                        OrderReviewView(
                            product: product,
                            fabric: fabric,
                            styleChoices: coordinator.selectedStyleChoices,
                            onOrderPlaced: { orderId in
                                coordinator.completeOrder(orderId: orderId)
                            }
                        )
                    } else {
                        Text("Please complete all previous steps")
                            .foregroundColor(.red)
                    }
                }
                
                // Navigation buttons
                HStack {
                    Button(action: {
                        if coordinator.currentStep == .productSelection {
                            coordinator.showCancelConfirmation = true
                        } else {
                            coordinator.moveToPreviousStep()
                        }
                    }) {
                        HStack {
                            Image(systemName: coordinator.currentStep == .productSelection ? "xmark" : "chevron.left")
                            Text(coordinator.currentStep == .productSelection ? "Cancel" : "Back")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        coordinator.moveToNextStep()
                    }) {
                        HStack {
                            Text(coordinator.currentStep == .orderReview ? "Place Order" : "Next")
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(coordinator.canProceed ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!coordinator.canProceed)
                }
                .padding()
            }
            .navigationTitle(coordinator.currentStep.title)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Cancel Order", isPresented: $coordinator.showCancelConfirmation) {
                Button("Continue Creating", role: .cancel) { }
                Button("Discard", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to cancel? Your progress will be lost.")
            }
            .fullScreenCover(isPresented: $coordinator.orderCompleted) {
                OrderCompletedView(orderId: coordinator.savedOrderId ?? "", onDismiss: {
                    dismiss()
                })
            }
        }
    }
}
