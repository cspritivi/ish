//
//  CachedAsyncImage.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/CachedAsyncImage.swift
import SwiftUI

struct CachedAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction,
                content: content
            )
        } else {
            // Fallback for iOS 14
            PlaceholderView()
        }
    }
    
    struct PlaceholderView: View {
        var body: some View {
            Image(systemName: "photo")
                .foregroundColor(.gray)
        }
    }
}
