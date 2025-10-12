
import SwiftUI

@available(iOS 14.0, *)
struct ClientOrderAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: GlassDataStore
    
    @State private var orderNumber: String = ""
    @State private var clientName: String = ""
    @State private var clientPhone: String = ""
    @State private var clientEmail: String = ""
    @State private var clientAddress: String = ""
    @State private var orderDetails: String = ""
    @State private var quantity: String = ""
    @State private var unitPrice: String = ""
    @State private var totalPrice: String = ""
    @State private var orderDate: Date = Date()
    @State private var expectedDeliveryDate: Date = Date().addingTimeInterval(86400 * 3)
    @State private var status: String = "New"
    @State private var paymentMethod: String = "Bank Transfer"
    @State private var paymentStatus: String = "Pending"
    @State private var discountPercent: String = "0.0"
    @State private var taxPercent: String = "10.0"
    @State private var shippingMethod: String = "Ground"
    @State private var shippingCost: String = "0.0"
    @State private var specialInstructions: String = ""
    @State private var handledBy: String = ""
    @State private var region: String = "East"
    @State private var priorityLevel: String = "Normal"
    @State private var confirmationCode: String = ""
    @State private var refundEligible: Bool = true
    @State private var tags: String = "client,new"
    
    @State private var showingAlert = false
    @State private var validationMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if orderNumber.isEmpty { errors.append("Order Number is required.") }
        if clientName.isEmpty { errors.append("Client Name is required.") }
        if clientPhone.count < 7 { errors.append("Client Phone is invalid.") }
        if !clientEmail.contains("@") || !clientEmail.contains(".") { errors.append("Client Email is invalid.") }
        if clientAddress.isEmpty { errors.append("Client Address is required.") }
        if orderDetails.isEmpty { errors.append("Order Details are required.") }
        if Int(quantity) == nil || (Int(quantity) ?? 0) <= 0 { errors.append("Quantity must be a positive number.") }
        if Double(unitPrice) == nil || (Double(unitPrice) ?? 0) <= 0 { errors.append("Unit Price must be a positive number.") }
        
        if errors.isEmpty {
            let finalQuantity = Int(quantity) ?? 0
            let finalUnitPrice = Double(unitPrice) ?? 0.0
            let finalDiscount = Double(discountPercent) ?? 0.0
            let finalTax = Double(taxPercent) ?? 0.0
            let finalShipping = Double(shippingCost) ?? 0.0
                        
            let newOrder = ClientOrder(
                id: UUID(),
                orderNumber: orderNumber,
                clientName: clientName,
                clientPhone: clientPhone,
                clientEmail: clientEmail,
                clientAddress: clientAddress,
                orderDetails: orderDetails,
                quantity: finalQuantity,
                unitPrice: finalUnitPrice,
                totalPrice: Double(totalPrice) ?? 0.0,
                orderDate: orderDate,
                expectedDeliveryDate: expectedDeliveryDate,
                status: status,
                paymentMethod: paymentMethod,
                paymentStatus: paymentStatus,
                discountPercent: finalDiscount,
                taxPercent: finalTax,
                shippingMethod: shippingMethod,
                shippingCost: finalShipping,
                specialInstructions: specialInstructions,
                handledBy: handledBy,
                region: region,
                priorityLevel: priorityLevel,
                confirmationCode: confirmationCode,
                refundEligible: refundEligible,
                tags: tags.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            )
            dataStore.addOrder(newOrder)
            validationMessage = "✅ Success! Client Order **\(newOrder.orderNumber)** has been added."
        } else {
            validationMessage = "❌ **Validation Errors:**\n" + errors.joined(separator: "\n")
        }
        
        showingAlert = true
    }
    
    private var calculatedTotalPrice: Double {
        let qty = Double(quantity) ?? 0
        let price = Double(unitPrice) ?? 0
        let discount = Double(discountPercent) ?? 0
        let tax = Double(taxPercent) ?? 0
        let shipping = Double(shippingCost) ?? 0
        
        let subtotal = qty * price
        let discounted = subtotal * (1 - discount / 100)
        let taxed = discounted * (1 + tax / 100)
        
        return taxed + shipping
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                ClientOrderAddSectionHeaderView(title: "Client Information", iconName: "person.text.rectangle.fill")
                
                ClientOrderAddGroupedFields {
                    ClientOrderAddFieldView(title: "Client Name", iconName: "person.fill", text: $clientName, keyboardType: .default)
                    ClientOrderAddFieldView(title: "Phone", iconName: "phone.fill", text: $clientPhone, keyboardType: .phonePad)
                    ClientOrderAddFieldView(title: "Email", iconName: "envelope.fill", text: $clientEmail, keyboardType: .emailAddress)
                    ClientOrderAddFieldView(title: "Address", iconName: "house.fill", text: $clientAddress, keyboardType: .default)
                }
                
                ClientOrderAddSectionHeaderView(title: "Order Details", iconName: "note.text")
                
                ClientOrderAddGroupedFields {
                    ClientOrderAddFieldView(title: "Order Number", iconName: "number.square.fill", text: $orderNumber, keyboardType: .default)
                    ClientOrderAddFieldView(title: "Order Description", iconName: "list.bullet.rectangle.fill", text: $orderDetails, keyboardType: .default)
                    ClientOrderAddFieldView(title: "Quantity", iconName: "cube.box.fill", text: $quantity, keyboardType: .numberPad)
                    ClientOrderAddFieldView(title: "Unit Price", iconName: "dollarsign.circle.fill", text: $unitPrice, keyboardType: .decimalPad)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Calculated Total: \(calculatedTotalPrice, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        ClientOrderAddFieldView(title: "Total Price (Override)", iconName: "banknote.fill", text: $totalPrice, keyboardType: .decimalPad)
                            .onAppear {
                                totalPrice = String(format: "%.2f", calculatedTotalPrice)
                            }
                    }
                }
                
                ClientOrderAddSectionHeaderView(title: "Timeline & Status", iconName: "calendar.badge.clock")
                
                ClientOrderAddGroupedFields {
                    ClientOrderAddDatePickerView(title: "Order Date", iconName: "calendar", date: $orderDate)
                    ClientOrderAddDatePickerView(title: "Expected Delivery", iconName: "shippingbox.fill", date: $expectedDeliveryDate)
                    ClientOrderAddPickerView(title: "Status", iconName: "arrow.triangle.2.circlepath", selection: $status, options: ["New", "Processing", "Manufactured", "Shipped", "Delivered", "Canceled"])
                    ClientOrderAddPickerView(title: "Priority", iconName: "exclamationmark.triangle.fill", selection: $priorityLevel, options: ["Low", "Normal", "High", "Critical"])
                    ClientOrderAddToggleView(title: "Refund Eligible", iconName: "dollarsign.arrow.circlepath", isOn: $refundEligible)
                    ClientOrderAddFieldView(title: "Confirmation Code", iconName: "checkmark.seal.fill", text: $confirmationCode, keyboardType: .default)
                }
                
                ClientOrderAddSectionHeaderView(title: "Financial & Logistics", iconName: "creditcard.fill")
                
                ClientOrderAddGroupedFields {
                    ClientOrderAddPickerView(title: "Payment Method", iconName: "creditcard", selection: $paymentMethod, options: ["Cash", "Bank Transfer", "Credit Card", "Cheque"])
                    ClientOrderAddPickerView(title: "Payment Status", iconName: "dollarsign.square.fill", selection: $paymentStatus, options: ["Pending", "Paid", "Refunded"])
                    ClientOrderAddFieldView(title: "Discount (%)", iconName: "tag.fill", text: $discountPercent, keyboardType: .decimalPad)
                    ClientOrderAddFieldView(title: "Tax (%)", iconName: "percent", text: $taxPercent, keyboardType: .decimalPad)
                    ClientOrderAddPickerView(title: "Shipping Method", iconName: "box.truck.fill", selection: $shippingMethod, options: ["Ground", "Air", "Sea", "Pickup"])
                    ClientOrderAddFieldView(title: "Shipping Cost", iconName: "figure.walk", text: $shippingCost, keyboardType: .decimalPad)
                }
                
                ClientOrderAddSectionHeaderView(title: "Internal Notes", iconName: "person.2.fill")
                
                ClientOrderAddGroupedFields {
                    ClientOrderAddFieldView(title: "Handled By", iconName: "person.crop.circle.fill", text: $handledBy, keyboardType: .default)
                    ClientOrderAddFieldView(title: "Region", iconName: "map.fill", text: $region, keyboardType: .default)
                    ClientOrderAddFieldView(title: "Tags (Comma Sep.)", iconName: "tag.circle.fill", text: $tags, keyboardType: .default)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Special Instructions")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextEditor(text: $specialInstructions)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
                
                Button(action: validateAndSave) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Save New Client Order")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
            }
            .padding(.top, 20)
            .padding(.bottom, 50)
        }
        .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationTitle("New Client Order")
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(validationMessage.contains("✅") ? "Submission Status" : "Validation Failed"),
                message: Text(validationMessage),
                dismissButton: .default(Text("OK")) {
                    if validationMessage.contains("✅") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}

@available(iOS 14.0, *)
struct ClientOrderAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .font(.title3)
            Text(title)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}

@available(iOS 14.0, *)
struct ClientOrderAddGroupedFields<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 15) {
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct ClientOrderAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    
    var isFloating: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(isFloating ? .blue : .gray)
                .opacity(isFloating ? 1 : 0)
                .offset(y: isFloating ? 0 : 20)
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                
                TextField(title, text: $text)
                    .keyboardType(keyboardType)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isFloating ? .blue : Color(.systemGray4)),
                alignment: .bottom
            )
        }
        .animation(.easeOut(duration: 0.2))
    }
}

@available(iOS 14.0, *)
struct ClientOrderAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
                .frame(width: 120)
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct ClientOrderAddPickerView: View {
    let title: String
    let iconName: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 120)
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct ClientOrderAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(.vertical, 5)
    }
}
