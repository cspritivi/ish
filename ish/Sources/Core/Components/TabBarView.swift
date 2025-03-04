//
//  TabBarView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Core/Components/TabBarView.swift (New)
import SwiftUI

enum Tab {
    case home
    case orders
    case account
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .orders:
            return "Orders"
        case .account:
            return "Account"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .orders:
            return "list.bullet.rectangle"
        case .account:
            return "person.circle"
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            ForEach([Tab.home, Tab.orders, Tab.account], id: \.self) { tab in
                Spacer()
                
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == tab ? tab.icon + ".fill" : tab.icon)
                            .font(.system(size: 22))
                        
                        Text(tab.title)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
}
