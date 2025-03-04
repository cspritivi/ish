//
//  StepIndicatorView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/StepIndicatorView.swift
import SwiftUI

struct StepIndicatorView: View {
    let step: OrderCreationStep
    let currentStep: OrderCreationStep
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(stepColor())
                    .frame(width: 30, height: 30)
                
                if currentStep.rawValue > step.rawValue {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                } else {
                    Text("\(step.rawValue + 1)")
                        .foregroundColor(currentStep == step ? .white : .black)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            
            Text(step.title)
                .font(.caption)
                .fontWeight(currentStep == step ? .semibold : .regular)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
    }
    
    private func stepColor() -> Color {
        if currentStep.rawValue > step.rawValue {
            return .green
        } else if currentStep == step {
            return .blue
        } else {
            return .gray.opacity(0.3)
        }
    }
}
