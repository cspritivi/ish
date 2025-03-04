//
//  StyleOptionSelectionView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Orders/Views/StyleOptionSectionView.swift
import SwiftUI
//import CachedAsyncImage

struct StyleOptionSectionView: View {
    let styleOption: StyleOption
    let selectedChoice: StyleOptionChoice?
    let onSelect: (StyleOptionChoice) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(styleOption.name)
                .font(.headline)
            
            Text(styleOption.type.rawValue)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(styleOption.options) { choice in
                        StyleChoiceView(
                            choice: choice,
                            isSelected: selectedChoice?.id == choice.id
                        )
                        .onTapGesture {
                            onSelect(choice)
                        }
                    }
                }
            }
            
            Divider()
        }
    }
}

