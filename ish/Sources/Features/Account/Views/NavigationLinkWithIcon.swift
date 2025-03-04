//
//  NavigationLinkWithIcon.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Account/Views/NavigationLinkWithIcon.swift (New)
import SwiftUI

struct NavigationLinkWithIcon<Destination: View>: View {
    let destination: Destination
    let icon: String
    let title: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 30)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

