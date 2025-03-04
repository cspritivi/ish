//
//  StatusBadgeView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/Views/StatusBadgeView.swift
import SwiftUI

struct StatusBadgeView: View {
    let status: OrderStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(getStatusColor(status).opacity(0.2))
            .foregroundColor(getStatusColor(status))
            .cornerRadius(8)
    }
    
    private func getStatusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .draft:
            return .gray
        case .pending:
            return .orange
        case .confirmed:
            return .blue
        case .inProduction:
            return .purple
        case .shipped:
            return .teal
        case .delivered:
            return .green
        case .cancelled:
            return .red
        }
    }
}

