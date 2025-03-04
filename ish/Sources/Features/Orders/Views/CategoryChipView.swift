//
//  CategoryChipView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/Views/CategoryChipView.swift
import SwiftUI

struct CategoryChipView: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
    }
}

