//
//  ProductCardView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/ProductCardView.swift
import SwiftUI
//import CachedAsyncImage

struct ProductCardView: View {
    let product: Product
    let isSelected: Bool
    
    var body: some View {
        VStack {
            if let firstImageURL = product.imageURLs.first, let url = URL(string: firstImageURL) {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                            .frame(height: 150)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "tshirt")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                    .frame(height: 150)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(product.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("$\(product.basePrice, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}
