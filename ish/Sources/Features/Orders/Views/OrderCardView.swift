//
//  OrderCardView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/Views/OrderCardView.swift
import SwiftUI

struct OrderCardView: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(order.product.name)
                    .font(.headline)
                
                Spacer()
                
                StatusBadgeView(status: order.status)
            }
            
            HStack {
                Text(order.fabric.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("$\(order.totalPrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Text("Ordered: \(formatDate(order.createdAt))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
