
import SwiftUI

@available(iOS 14.0, *)
struct DeliveryRecordAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: GlassDataStore
    
    @State private var deliveryNumber: String = ""
    @State private var driverName: String = ""
    @State private var vehicleID: String = ""
    @State private var licensePlate: String = ""
    @State private var routeCode: String = ""
    @State private var startLocation: String = ""
    @State private var destination: String = ""
    @State private var distanceKM: String = ""
    @State private var estimatedTimeMinutes: String = ""
    @State private var actualTimeMinutes: String = ""
    @State private var fuelUsedLiters: String = ""
    @State private var startDate: Date = Date()
    @State private var deliveryDate: Date = Date().addingTimeInterval(3600)
    @State private var isDelivered: Bool = false
    @State private var status: String = "Pending"
    @State private var packageCount: String = ""
    @State private var fragileItems: String = ""
    @State private var temperatureRequirement: String = "Ambient"
    @State private var deliveryNotes: String = ""
    @State private var receiverName: String = ""
    @State private var receiverSignature: String = ""
    @State private var feedbackRating: String = ""
    @State private var issueReported: Bool = false
    @State private var issueDescription: String = ""
    @State private var completionCode: String = ""
    @State private var tags: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if deliveryNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Delivery Number is required.") }
        if driverName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Driver Name is required.") }
        if vehicleID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Vehicle ID is required.") }
        if licensePlate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("License Plate is required.") }
        if routeCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Route Code is required.") }
        if startLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Start Location is required.") }
        if destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Destination is required.") }
        if completionCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Completion Code is required.") }
        
        let dKM = Double(distanceKM)
        if dKM == nil || dKM! <= 0 { errors.append("Distance (KM) must be a positive number.") }
        
        let eTime = Int(estimatedTimeMinutes)
        if eTime == nil || eTime! <= 0 { errors.append("Estimated Time must be a positive integer.") }
        
        let aTime = Int(actualTimeMinutes)
        if aTime == nil || aTime! <= 0 { errors.append("Actual Time must be a positive integer.") }
        
        let fUsed = Double(fuelUsedLiters)
        if fUsed == nil || fUsed! <= 0 { errors.append("Fuel Used must be a positive number.") }
        
        let pCount = Int(packageCount)
        if pCount == nil || pCount! < 0 { errors.append("Package Count must be a non-negative integer.") }
        
        let fItems = Int(fragileItems)
        if fItems == nil || fItems! < 0 { errors.append("Fragile Items count must be a non-negative integer.") }
        
        let fRating = Int(feedbackRating)
        if fRating == nil || fRating! < 1 || fRating! > 5 { errors.append("Feedback Rating must be an integer between 1 and 5.") }
        
        if issueReported && issueDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Issue Description is required if an issue is reported.")
        }
        
        if errors.isEmpty {
            let newRecord = DeliveryRecord(
                id: UUID(),
                deliveryNumber: deliveryNumber,
                driverName: driverName,
                vehicleID: vehicleID,
                licensePlate: licensePlate,
                routeCode: routeCode,
                startLocation: startLocation,
                destination: destination,
                distanceKM: dKM!,
                estimatedTimeMinutes: eTime!,
                actualTimeMinutes: aTime!,
                fuelUsedLiters: fUsed!,
                startDate: startDate,
                deliveryDate: deliveryDate,
                isDelivered: isDelivered,
                status: status,
                packageCount: pCount!,
                fragileItems: fItems!,
                temperatureRequirement: temperatureRequirement,
                deliveryNotes: deliveryNotes,
                receiverName: receiverName,
                receiverSignature: receiverSignature,
                feedbackRating: fRating!,
                issueReported: issueReported,
                issueDescription: issueReported ? issueDescription : "",
                completionCode: completionCode,
                tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            )
            
            dataStore.addDelivery(newRecord)
            
            alertMessage = "✅ Success!\n\nThe new delivery record \(deliveryNumber) has been saved."
            showAlert = true
        } else {
            alertMessage = "❌ Validation Errors:\n\n" + errors.joined(separator: "\n")
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    DeliveryRecordAddSectionHeaderView(
                        title: "Shipment Details",
                        subtitle: "Core identifier and logistical information.",
                        iconName: "shippingbox.fill"
                    )
                    
                    VStack(spacing: 15) {
                        DeliveryRecordAddFieldView(title: "Delivery Number", iconName: "number.square.fill", text: $deliveryNumber)
                        DeliveryRecordAddFieldView(title: "Route Code", iconName: "map.fill", text: $routeCode)
                        DeliveryRecordAddFieldView(title: "Package Count", iconName: "box.stack.fill", text: $packageCount, keyboardType: .numberPad)
                        DeliveryRecordAddFieldView(title: "Fragile Items Count", iconName: "hand.raised.fill", text: $fragileItems, keyboardType: .numberPad)
                    }
                    .padding(.horizontal)
                    
                    DeliveryRecordAddSectionHeaderView(
                        title: "Driver & Vehicle",
                        subtitle: "Personnel and transport details.",
                        iconName: "car.fill"
                    )
                    
                    VStack(spacing: 15) {
                        DeliveryRecordAddFieldView(title: "Driver Name", iconName: "person.circle.fill", text: $driverName)
                        DeliveryRecordAddFieldView(title: "Vehicle ID", iconName: "car.top.door.sliding", text: $vehicleID)
                        DeliveryRecordAddFieldView(title: "License Plate", iconName: "numberplate.fill", text: $licensePlate)
                    }
                    .padding(.horizontal)
                    
                    DeliveryRecordAddSectionHeaderView(
                        title: "Timing & Location",
                        subtitle: "Distance, time, and coordinates.",
                        iconName: "clock.fill"
                    )
                    
                    VStack(spacing: 15) {
                        DeliveryRecordAddFieldView(title: "Start Location", iconName: "location.north.fill", text: $startLocation)
                        DeliveryRecordAddFieldView(title: "Destination", iconName: "map.pin.circle.fill", text: $destination)
                        
                        HStack {
                            DeliveryRecordAddFieldView(title: "Distance (KM)", iconName: "ruler.fill", text: $distanceKM, keyboardType: .decimalPad)
                            DeliveryRecordAddFieldView(title: "Fuel Used (L)", iconName: "fuelpump.fill", text: $fuelUsedLiters, keyboardType: .decimalPad)
                        }
                        .padding(.horizontal)
                        
                        DeliveryRecordAddDatePickerView(title: "Scheduled Start Date", iconName: "calendar.badge.clock", date: $startDate)
                        DeliveryRecordAddDatePickerView(title: "Actual Delivery Date", iconName: "calendar.badge.checkmark", date: $deliveryDate)
                        
                        HStack {
                            DeliveryRecordAddFieldView(title: "Est. Time (Min)", iconName: "timer", text: $estimatedTimeMinutes, keyboardType: .numberPad)
                            DeliveryRecordAddFieldView(title: "Actual Time (Min)", iconName: "clock.arrow.circlepath", text: $actualTimeMinutes, keyboardType: .numberPad)
                        }
                        .padding(.horizontal)
                    }
                    
                    DeliveryRecordAddSectionHeaderView(
                        title: "Completion & Feedback",
                        subtitle: "Final status and post-delivery details.",
                        iconName: "checkmark.circle.fill"
                    )
                    
                    VStack(spacing: 15) {
                        
                        HStack {
                            Toggle(isOn: $isDelivered) {
                                Text("Delivered?")
                                    .fontWeight(.medium)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .padding(.horizontal, 15)
                            
                            Toggle(isOn: $issueReported) {
                                Text("Issue Reported?")
                                    .fontWeight(.medium)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .red))
                            .padding(.horizontal, 15)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        if issueReported {
                            DeliveryRecordAddFieldView(title: "Issue Description", iconName: "exclamationmark.triangle.fill", text: $issueDescription)
                                .padding(.horizontal)
                        }
                        
                        DeliveryRecordAddFieldView(title: "Receiver Name", iconName: "person.text.rectangle.fill", text: $receiverName)
                            .padding(.horizontal)
                        
                        DeliveryRecordAddFieldView(title: "Feedback Rating (1-5)", iconName: "star.fill", text: $feedbackRating, keyboardType: .numberPad)
                            .padding(.horizontal)
                        
                        DeliveryRecordAddFieldView(title: "Delivery Notes", iconName: "note.text", text: $deliveryNotes)
                            .padding(.horizontal)
                        
                        DeliveryRecordAddFieldView(title: "Completion Code", iconName: "lock.fill", text: $completionCode)
                            .padding(.horizontal)
                        
                        DeliveryRecordAddFieldView(title: "Receiver Signature", iconName: "signature", text: $receiverSignature)
                            .padding(.horizontal)
                        DeliveryRecordAddFieldView(title: "Temperature Requirement", iconName: "thermometer", text: $temperatureRequirement)
                            .padding(.horizontal)
                        DeliveryRecordAddFieldView(title: "Status", iconName: "doc.text.fill", text: $status)
                            .padding(.horizontal)
                        DeliveryRecordAddFieldView(title: "Tags (Comma Separated)", iconName: "tag.fill", text: $tags)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: validateAndSave) {
                        Text("Record Delivery")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("New Delivery Record 🚚")
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Submission Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("✅ Success") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


@available(iOS 14.0, *)
struct DeliveryRecordAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    @State private var isFocused: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(isFocused || !text.isEmpty ? Color.blue : Color.gray)
                    .frame(width: 20)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isFocused || !text.isEmpty ? Color.blue : Color.gray)
                    .offset(y: isFocused || !text.isEmpty ? -25 : 0)
                    .animation(.spring(), value: isFocused)
                
                Spacer()
            }
            .padding(.horizontal, 10)
            
            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, -15)
            .onTapGesture {
                self.isFocused = true
            }
            .onDisappear {
                self.isFocused = false
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused ? .blue : Color(.systemGray4))
        }
        .padding(.top, 15)
        .padding(.horizontal, 15)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

@available(iOS 14.0, *)
struct DeliveryRecordAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .foregroundColor(.purple)
            Text(title)
                .fontWeight(.medium)
            Spacer()
            DatePicker("", selection: $date)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
                .scaleEffect(0.9)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal, 15)
    }
}

@available(iOS 14.0, *)
struct DeliveryRecordAddSectionHeaderView: View {
    let title: String
    let subtitle: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(.orange)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
    }
}
