//
//  OrderCreationCoordinator.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/ViewModels/OrderCreationCoordinator.swift
import Foundation
import SwiftUI

enum OrderCreationStep: Int, CaseIterable {
    case productSelection = 0
    case fabricSelection = 1
    case styleCustomization = 2
    case orderReview = 3
    
    var title: String {
        switch self {
        case .productSelection:
            return "Select Product"
        case .fabricSelection:
            return "Choose Fabric"
        case .styleCustomization:
            return "Customize Style"
        case .orderReview:
            return "Review Order"
        }
    }
}

class OrderCreationCoordinator: ObservableObject {
    @Published var currentStep: OrderCreationStep = .productSelection
    @Published var selectedProduct: Product?
    @Published var selectedFabric: Fabric?
    @Published var selectedStyleChoices: [String: StyleOptionChoice] = [:]
    @Published var orderCompleted = false
    @Published var savedOrderId: String?
    @Published var showCancelConfirmation = false
    
    var canProceed: Bool {
        switch currentStep {
        case .productSelection:
            return selectedProduct != nil
        case .fabricSelection:
            return selectedFabric != nil
        case .styleCustomization:
            return !selectedStyleChoices.isEmpty
        case .orderReview:
            return true
        }
    }
    
    var progress: Float {
        Float(currentStep.rawValue) / Float(OrderCreationStep.allCases.count - 1)
    }
    
    func moveToNextStep() {
        guard canProceed else { return }
        
        let nextStepRawValue = currentStep.rawValue + 1
        guard nextStepRawValue < OrderCreationStep.allCases.count else { return }
        
        currentStep = OrderCreationStep(rawValue: nextStepRawValue) ?? .productSelection
    }
    
    func moveToPreviousStep() {
        let prevStepRawValue = currentStep.rawValue - 1
        guard prevStepRawValue >= 0 else { return }
        
        currentStep = OrderCreationStep(rawValue: prevStepRawValue) ?? .productSelection
    }
    
    func selectProduct(_ product: Product) {
        selectedProduct = product
    }
    
    func selectFabric(_ fabric: Fabric) {
        selectedFabric = fabric
    }
    
    func updateStyleChoices(_ choices: [String: StyleOptionChoice]) {
        selectedStyleChoices = choices
    }
    
    func resetOrder() {
        currentStep = .productSelection
        selectedProduct = nil
        selectedFabric = nil
        selectedStyleChoices = [:]
        orderCompleted = false
        savedOrderId = nil
    }
    
    func completeOrder(orderId: String) {
        savedOrderId = orderId
        orderCompleted = true
    }
}
