//
//  OrderCompletedView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/OrderCompletedView.swift
import SwiftUI

struct OrderCompletedView: View {
    let orderId: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Order Placed!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your order has been successfully placed and is now being processed.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Order Number:")
                    .font(.headline)
                Text(orderId)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: onDismiss) {
                Text("Continue Shopping")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
