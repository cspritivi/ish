//
//  Logo.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/22/25.
//
import SwiftUI

struct LogoView: View {
    
    let size: CGFloat
    let padding: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            Text("IS")
                .font(.voga(size: size))
                .foregroundStyle(Color.primary)
            Text("H")
                .font(.voga(size: size))
                .foregroundStyle(Color.red)
            Text("WAR")
                .font(.voga(size: size))
                .foregroundStyle(Color.primary)
        }
        .padding(.all, padding)
    }
}

#Preview {
    LogoView(size: 100, padding: 4)
}
