//
//  QuickActionCard.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
import SwiftUI

struct QuickActionCard: View {
    let icon: String
    let title: String
    var action: (() -> Void)? = nil
    var isNavigationLink: Bool = false
    
    var body: some View {
        Group {
            // If it's not intended to be inside a NavigationLink, use a Button
            if !isNavigationLink {
                Button(action: {
                    action?()
                }) {
                    cardContent
                }
            } else {
                // Otherwise, just show the content without a Button
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
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

// Usage in HomeView would be:
// NavigationLink(destination: MeasurementListView()) {
//     QuickActionCard(
//         icon: "ruler",
//         title: "Measurements",
//         isNavigationLink: true
//     )
// }
