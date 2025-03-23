//
//  MainTabView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Core/MainTabView.swift (New)
import SwiftUI

struct MainTabView: View {
    @StateObject private var authService = AuthService.shared
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(Tab.home)
                    
                    OrderListView()
                        .tag(Tab.orders)
                    
                    AccountView()
                        .tag(Tab.account)
                }
                .overlay(
                    VStack {
                        Spacer()
                        TabBarView(selectedTab: $selectedTab)
                    }
                    .ignoresSafeArea(.keyboard)
                )
                .ignoresSafeArea(.keyboard)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
