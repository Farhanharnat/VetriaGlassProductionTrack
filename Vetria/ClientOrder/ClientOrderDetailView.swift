
import SwiftUI

@available(iOS 14.0, *)
struct ClientOrderDetailView: View {
    let order: ClientOrder
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    private func currencyString(for value: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: value)) ?? String(format: "$%.2f", value)
    }
    
    private func percentString(for value: Double) -> String {
        return String(format: "%.1f%%", value)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Order #\(order.orderNumber)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.blue)
                    Text(order.clientName)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                ClientOrderDetailGroupView(title: "Status & Timeline", icon: "calendar.badge.clock") {
                    HStack(spacing: 15) {
                        ClientOrderDetailStatusBadge(label: "STATUS", value: order.status, color: statusColor)
                        ClientOrderDetailStatusBadge(label: "PRIORITY", value: order.priorityLevel, color: priorityColor)
                        ClientOrderDetailStatusBadge(label: "REFUND", value: order.refundEligible ? "Eligible" : "Not Eligible", color: order.refundEligible ? Color.green : Color.red)
                    }
                    .padding(.bottom, 10)
                    
                    ClientOrderDetailFieldRow(label: "Order Date", value: dateFormatter.string(from: order.orderDate), icon: "calendar")
                    ClientOrderDetailFieldRow(label: "Expected Delivery", value: dateFormatter.string(from: order.expectedDeliveryDate), icon: "shippingbox.fill")
                    ClientOrderDetailFieldRow(label: "Handled By", value: order.handledBy, icon: "person.crop.circle")
                    ClientOrderDetailFieldRow(label: "Confirmation Code", value: order.confirmationCode, icon: "checkmark.seal.fill")
                }
                
                ClientOrderDetailGroupView(title: "Financial Overview", icon: "creditcard.fill") {
                VStack(spacing: 15) {
                        ClientOrderDetailMetricView(label: "Total Price", value: currencyString(for: order.totalPrice), icon: "banknote.fill", color: Color.green)
                        ClientOrderDetailMetricView(label: "Quantity", value: "\(order.quantity)", icon: "cube.box.fill", color: Color.orange)
                    }
                    .padding(.bottom, 10)
                    
                    ClientOrderDetailFieldRow(label: "Unit Price", value: currencyString(for: order.unitPrice), icon: "dollarsign.circle")
                    ClientOrderDetailFieldRow(label: "Payment Status", value: order.paymentStatus, icon: "dollarsign.square")
                    ClientOrderDetailFieldRow(label: "Payment Method", value: order.paymentMethod, icon: "creditcard")
                    ClientOrderDetailFieldRow(label: "Discount", value: percentString(for: order.discountPercent), icon: "tag.slash.fill")
                    ClientOrderDetailFieldRow(label: "Tax", value: percentString(for: order.taxPercent), icon: "percent")
                    ClientOrderDetailFieldRow(label: "Shipping Cost", value: currencyString(for: order.shippingCost), icon: "figure.walk")
                }
                
                ClientOrderDetailGroupView(title: "Client & Shipping", icon: "person.text.rectangle.fill") {
                    ClientOrderDetailFieldRow(label: "Client Phone", value: order.clientPhone, icon: "phone.fill")
                    ClientOrderDetailFieldRow(label: "Client Email", value: order.clientEmail, icon: "envelope.fill")
                    ClientOrderDetailFieldRow(label: "Client Address", value: order.clientAddress, icon: "house.fill")
                    ClientOrderDetailFieldRow(label: "Region", value: order.region, icon: "map.fill")
                    ClientOrderDetailFieldRow(label: "Shipping Method", value: order.shippingMethod, icon: "box.truck.fill")
                }
                
                ClientOrderDetailGroupView(title: "Order Description & Notes", icon: "note.text") {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Order Details")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(order.orderDetails)
                            .font(.body)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Special Instructions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(order.specialInstructions.isEmpty ? "N/A" : order.specialInstructions)
                            .font(.body)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ClientOrderDetailTagsView(tags: order.tags)
                }
                
            }
            .padding(.vertical, 20)
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Order Detail")
    }
    
    private var statusColor: Color {
        switch order.status {
        case "Delivered": return Color.init(red: 0.1, green: 0.6, blue: 0.2)
        case "Processing": return Color.orange
        case "Canceled": return Color.red
        default: return Color.blue
        }
    }
    
    private var priorityColor: Color {
        switch order.priorityLevel {
        case "High", "Critical": return Color.red
        case "Normal": return Color.orange
        default: return Color(.systemTeal)
        }
    }
}

@available(iOS 14.0, *)
struct ClientOrderDetailGroupView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.purple)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.bottom, 5)
            
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct ClientOrderDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(width: 150, alignment: .leading)
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
            
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
struct ClientOrderDetailStatusBadge: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(value)
                .font(.subheadline)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct ClientOrderDetailMetricView: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                // Fill background
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.05))
                
                // Border stroke
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.5), lineWidth: 2)
            }
        )
    }
}


@available(iOS 14.0, *)
struct ClientOrderDetailTagsView: View {
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Tags")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 6) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemTeal).opacity(0.15))
                        .foregroundColor(Color(.systemTeal))
                        .cornerRadius(4)
                }
            }
        }
    }
}
