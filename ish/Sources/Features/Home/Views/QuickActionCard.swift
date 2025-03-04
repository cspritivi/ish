//
//  QuickActionCard.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Home/Views/QuickActionCard.swift (New)
import SwiftUI

struct QuickActionCard: View {
    let icon: String
    let title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

