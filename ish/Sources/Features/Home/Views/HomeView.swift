//
//  HomeView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//
// ish/Sources/Features/Home/Views/HomeView.swift (New)
import SwiftUI

struct HomeView: View {
    @State private var showNewOrder = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Banner
                    ZStack(alignment: .bottomLeading) {
                        Image(systemName: "rectangle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .foregroundColor(.blue.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Custom Tailored Perfection")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Create your personalized garment today")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Button(action: {
                                showNewOrder = true
                            }) {
                                Text("Start Now")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                    }
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Browse Categories")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(ProductCategory.allCases) { category in
                                    CategoryCard(category: category)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Quick actions
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            QuickActionCard(
                                icon: "plus.circle.fill",
                                title: "New Order",
                                action: { showNewOrder = true }
                            )
                            
                            NavigationLink(destination: MeasurementListView()) {
                                QuickActionCard(
                                    icon: "ruler",
                                    title: "Measurements",
                                    isNavigationLink: true
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showNewOrder) {
                OrderCreationView()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    LogoView(size: 40, padding: 0)
                        .padding(.top, 5)
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView()
}
