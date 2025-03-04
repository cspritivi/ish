//
//  FabricCardView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/FabricCardView.swift
import SwiftUI
//import CachedAsyncImage

struct FabricCardView: View {
    let fabric: Fabric
    let isSelected: Bool
    
    var body: some View {
        VStack {
            if let url = URL(string: fabric.imageURL) {
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
                Image(systemName: "swift")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                    .frame(height: 150)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(fabric.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text(fabric.color)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                    
                    Text(fabric.pattern.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Text("\(fabric.material) • \(fabric.priceMultiplier)x")
                    .font(.caption)
                    .foregroundColor(.gray)
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
