//
//  ContentView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 2/21/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var authService = AuthService.shared
    
    var body: some View {
        NavigationView {
            Group {
                if authService.isAuthenticated {
                    AccountView()
                } else {
                    LoginView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
