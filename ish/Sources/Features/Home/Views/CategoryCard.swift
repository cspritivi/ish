//
//  CategoryCard.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Home/Views/CategoryCard.swift (New)
import SwiftUI

struct CategoryCard: View {
    let category: ProductCategory
    
    var body: some View {
        VStack {
            Image(systemName: iconFor(category))
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
            
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(width: 80)
    }
    
    private func iconFor(_ category: ProductCategory) -> String {
        switch category {
        case .suit:
            return "person.fill"
        case .shirt:
            return "tshirt.fill"
        case .trousers:
            return "scissors"
        case .blazer:
            return "person.fill"
        case .waistcoat:
            return "person.crop.square"
        case .accessories:
            return "giftcard"
        }
    }
}
