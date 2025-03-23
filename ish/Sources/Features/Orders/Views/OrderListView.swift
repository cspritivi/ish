//
//  OrderListView.swift
//  ish
//
//  Created by Pritivi S Chhabria on 3/2/25.
//

// ish/Sources/Features/Orders/Views/OrderListView.swift
import SwiftUI


struct OrderListView: View {
    @StateObject private var viewModel = OrderListViewModel()
    @State private var showNewOrder = false
    @State private var selectedOrder: Order?
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.orders.isEmpty {
                LoadingView()
            } else if viewModel.orders.isEmpty {
                EmptyOrdersView(showNewOrder: $showNewOrder)
            } else {
                OrdersContentView(
                    viewModel: viewModel,
                    selectedOrder: $selectedOrder
                )
            }
        }
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showNewOrder = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewOrder) {
            OrderCreationView()
        }
        .sheet(item: $selectedOrder) { order in
            NavigationView {
                OrderDetailView(order: order)
            }
        }
        .onAppear {
            viewModel.fetchOrders()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading orders...")
    }
}

struct EmptyOrdersView: View {
    @Binding var showNewOrder: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tshirt")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No orders yet")
                .font(.headline)
            
            Text("Start creating your custom clothing order")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Button(action: { showNewOrder = true }) {
                Text("Create New Order")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(width: 220)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct OrdersContentView: View {
    @ObservedObject var viewModel: OrderListViewModel
    @Binding var selectedOrder: Order?
    
    var body: some View {
        VStack {
            StatusFilterView(selectedStatus: $viewModel.selectedStatus)
            
            if viewModel.filteredOrders.isEmpty {
                NoMatchingOrdersView(viewModel: viewModel)
            } else {
                OrdersList(
                    viewModel: viewModel,
                    selectedOrder: $selectedOrder
                )
            }
        }
    }
}

struct StatusFilterView: View {
    @Binding var selectedStatus: OrderStatus?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button(action: {
                    selectedStatus = nil
                }) {
                    CategoryChipView(
                        title: "All",
                        isSelected: selectedStatus == nil
                    )
                }
                
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    Button(action: {
                        selectedStatus = status
                    }) {
                        CategoryChipView(
                            title: status.rawValue,
                            isSelected: selectedStatus == status
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct NoMatchingOrdersView: View {
    @ObservedObject var viewModel: OrderListViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No orders match your filter")
                .font(.headline)
            
            Button("Clear Filter") {
                viewModel.selectedStatus = nil
            }
            .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct OrdersList: View {
    
    let viewModel: OrderListViewModel
    @Binding var selectedOrder: Order?
    
    var body: some View {
        List {
            ForEach(viewModel.filteredOrders) { order in
                OrderCardView(order: order)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedOrder = order
                    }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    if index >= 0 && index < viewModel.filteredOrders.count {
                        let orderToDelete = viewModel.filteredOrders[index]
                        viewModel.deleteOrder(id: orderToDelete.id)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .refreshable {
            viewModel.fetchOrders()
        }
    }
}

#Preview {
    NavigationView {
        OrderListView()
    }
}
