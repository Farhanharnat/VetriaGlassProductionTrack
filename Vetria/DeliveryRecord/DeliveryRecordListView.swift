
import SwiftUI

@available(iOS 14.0, *)
struct DeliveryRecordListView: View {
    @EnvironmentObject var dataStore: GlassDataStore
    @State private var searchText: String = ""
    @State private var isAddingNewRecord: Bool = false
    
    var filteredRecords: [DeliveryRecord] {
        if searchText.isEmpty {
            return dataStore.deliveries
        } else {
            return dataStore.deliveries.filter { record in
                record.driverName.localizedCaseInsensitiveContains(searchText) ||
                record.deliveryNumber.localizedCaseInsensitiveContains(searchText) ||
                record.destination.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func deleteRecords(at offsets: IndexSet) {
        offsets.forEach { index in
            let recordToDelete = filteredRecords[index]
            dataStore.deleteDelivery(recordToDelete.id)
        }
    }
    
    var body: some View {
            VStack {
                
                DeliveryRecordSearchBarView(searchText: $searchText)
                
                if filteredRecords.isEmpty {
                    DeliveryRecordNoDataView()
                } else {
                    List {
                        ForEach(filteredRecords) { record in
                            NavigationLink(destination: DeliveryRecordDetailView(record: record)) {
                                DeliveryRecordListRowView(record: record)
                                    .padding(.vertical, 5)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .background(Color(.systemGroupedBackground))
                        }
                        .onDelete(perform: deleteRecords)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, -10)
                }
            }
            .navigationTitle("Delivery Log 📋")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isAddingNewRecord = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .background(
                NavigationLink(
                    destination: DeliveryRecordAddView(),
                    isActive: $isAddingNewRecord,
                    label: { EmptyView() }
                )
                .hidden()
            )
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


@available(iOS 14.0, *)
struct DeliveryRecordNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "archivebox.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            Text("No Delivery Records Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Looks like you haven't recorded any deliveries yet. Tap the '+' button to add the first one!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 50)
    }
}

@available(iOS 14.0, *)
struct DeliveryRecordSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .gray : .blue)
            
            TextField("Search by Driver or Delivery ID...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: 40)
            
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding([.horizontal, .top])
        .animation(.default, value: searchText.isEmpty)
    }
}

@available(iOS 14.0, *)
struct DeliveryRecordListRowView: View {
    let record: DeliveryRecord
    
    private var statusColor: Color {
        switch record.status.lowercased() {
        case "completed": return .green
        case "pending": return .orange
        case "in transit": return .blue
        case "failed": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.deliveryNumber)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Route: \(record.routeCode)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(record.status.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(statusColor)
                    .cornerRadius(5)
            }
            .padding(.bottom, 5)
            
            Group {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        DeliveryRecordListInfoPair(icon: "person.fill", label: "Driver", value: record.driverName)
                        DeliveryRecordListInfoPair(icon: "car.fill", label: "License", value: record.licensePlate)
                        DeliveryRecordListInfoPair(icon: "mappin.and.ellipse", label: "Start Loc", value: record.startLocation)
                        DeliveryRecordListInfoPair(icon: "stopwatch.fill", label: "Est. Time", value: "\(record.estimatedTimeMinutes) Min")
                        DeliveryRecordListInfoPair(icon: "box.stack.fill", label: "Packs", value: "\(record.packageCount)")
                        DeliveryRecordListInfoPair(icon: "thermometer", label: "Temp Req", value: record.temperatureRequirement)
                        DeliveryRecordListInfoPair(icon: "lock.fill", label: "Comp Code", value: record.completionCode)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        DeliveryRecordListInfoPair(icon: "building.2.fill", label: "Destination", value: record.destination)
                        DeliveryRecordListInfoPair(icon: "fuelpump.fill", label: "Fuel Used", value: String(format: "%.1f L", record.fuelUsedLiters))
                        DeliveryRecordListInfoPair(icon: "clock.fill", label: "Actual Time", value: "\(record.actualTimeMinutes) Min")
                        DeliveryRecordListInfoPair(icon: "star.fill", label: "Rating", value: "\(record.feedbackRating)/5")
                        DeliveryRecordListInfoPair(icon: "hand.raised.fill", label: "Fragile", value: "\(record.fragileItems)")
                        DeliveryRecordListInfoPair(icon: "checkmark.seal.fill", label: "Delivered", value: record.isDelivered ? "Yes" : "No", accentColor: record.isDelivered ? .green : .red)
                        DeliveryRecordListInfoPair(icon: "exclamationmark.triangle.fill", label: "Issue", value: record.issueReported ? "Yes" : "No", accentColor: record.issueReported ? .red : .green)
                        DeliveryRecordListInfoPair(icon: "tag.fill", label: "Tags", value: record.tags.joined(separator: ", "))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Divider()
            
            HStack {
                Text(record.deliveryNotes.isEmpty ? "No notes." : record.deliveryNotes)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Receiver: \(record.receiverName)")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            .padding(.top, 5)
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal,10)
    }
}

@available(iOS 14.0, *)
struct DeliveryRecordListInfoPair: View {
    let icon: String
    let label: String
    let value: String
    var isDate: Bool = false
    var accentColor: Color? = nil
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text("\(label):")
                .font(.caption)
                .fontWeight(.medium)
            
            Text(isDate ? (value as NSString).dateValue()?.formattedDate() ?? value : value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(accentColor ?? .primary)
                .lineLimit(1)
        }
    }
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

extension NSString {
    func dateValue() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self as String)
    }
}
