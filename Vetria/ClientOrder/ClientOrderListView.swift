
import SwiftUI
import Combine


@available(iOS 14.0, *)
struct ClientOrderListView: View {
    @EnvironmentObject var dataStore: GlassDataStore
    @State private var searchText: String = ""
    @State private var isAddViewActive: Bool = false
    
    private var filteredOrders: [ClientOrder] {
        if searchText.isEmpty {
            return dataStore.orders
        } else {
            return dataStore.orders.filter { order in
                order.orderNumber.localizedCaseInsensitiveContains(searchText) ||
                order.clientName.localizedCaseInsensitiveContains(searchText) ||
                order.status.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack {
                ClientOrderSearchBarView(searchText: $searchText)
                
                if filteredOrders.isEmpty {
                    ClientOrderNoDataView(message: searchText.isEmpty ? "No orders have been added yet." : "No results found for '\(searchText)'")
                } else {
                    List {
                        ForEach(filteredOrders) { order in
                            NavigationLink(destination: ClientOrderDetailView(order: order)) {
                                ClientOrderListRowView(order: order)
                                    .padding(.vertical, 5)
                            }
                        }
                        .onDelete(perform: deleteOrders)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Client Orders")
            .background(
                NavigationLink(destination: ClientOrderAddView().environmentObject(dataStore), isActive: $isAddViewActive) {
                    EmptyView()
                }
            )
            .navigationBarItems(trailing:
                                    Button(action: {
                isAddViewActive = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            )
        
    }
    
    private func deleteOrders(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredOrders[$0] }.forEach { order in
                dataStore.deleteOrder(order.id)
            }
        }
    }
}

@available(iOS 14.0, *)
struct ClientOrderSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search by #, Client, or Status...", text: $searchText, onEditingChanged: { editing in
                withAnimation(.easeOut(duration: 0.2)) {
                    isEditing = editing
                }
            })
            .padding(10)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if isEditing {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        isEditing = false
                        searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }) {
                    Text("Cancel")
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct ClientOrderListRowView: View {
    let order: ClientOrder
    
    private var statusColor: Color {
        switch order.status {
        case "Delivered": return Color.init(red: 0.1, green: 0.6, blue: 0.2) 
        case "Processing": return Color.orange
        case "Canceled": return Color.red
        case "Shipped": return Color.blue
        default: return Color(.systemGray)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(order.clientName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    HStack(spacing: 5) {
                        Image(systemName: "number")
                        Text(order.orderNumber)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Text(order.status)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.15))
                    .foregroundColor(statusColor)
                    .cornerRadius(6)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    ClientOrderListRowDetailItem(icon: "dollarsign.circle.fill", label: "Total", value: numberFormatter.string(from: NSNumber(value: order.totalPrice)) ?? "$0.00", color: Color.green)
                    Spacer()
                    ClientOrderListRowDetailItem(icon: "cube.box.fill", label: "Qty", value: "\(order.quantity)", color: Color(.systemOrange))
                }
                
                HStack {
                    ClientOrderListRowDetailItem(icon: "calendar.badge.clock", label: "Delivery", value: dateFormatter.string(from: order.expectedDeliveryDate), color: Color.blue)
                    Spacer()
                    ClientOrderListRowDetailItem(icon: "bolt.horizontal.fill", label: "Priority", value: order.priorityLevel, color: order.priorityLevel == "High" ? Color.red : Color(.systemTeal))
                }
                
                HStack {
                    ClientOrderListRowDetailItem(icon: "tag.fill", label: "Payment", value: order.paymentStatus, color: order.paymentStatus == "Paid" ? Color.green : Color.yellow)
                    Spacer()
                    ClientOrderListRowDetailItem(icon: "person.crop.circle.fill", label: "Handler", value: order.handledBy, color: Color(.systemPurple))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct ClientOrderListRowDetailItem: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
        .frame(minWidth: 120, alignment: .leading)
    }
}

@available(iOS 14.0, *)
struct ClientOrderNoDataView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "tray.fill")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text("No Orders Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: {
                
            }) {
                Text("Refresh Data")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
