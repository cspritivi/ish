//
//  StyleChoiceView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/StyleChoiceView.swift
import SwiftUI
//import CachedAsyncImage

struct StyleChoiceView: View {
    let choice: StyleOptionChoice
    let isSelected: Bool
    
    var body: some View {
        VStack {
            if let url = URL(string: choice.imageURL), !choice.imageURL.isEmpty {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 80)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 80)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundColor(.gray)
                            .frame(width: 120, height: 80)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                    .frame(width: 120, height: 80)
            }
            
            VStack(spacing: 4) {
                Text(choice.name)
                    .font(.subheadline)
                    .lineLimit(1)
                
                if choice.additionalPrice > 0 {
                    Text("+$\(choice.additionalPrice, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 4)
        }
        .frame(width: 120)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}
