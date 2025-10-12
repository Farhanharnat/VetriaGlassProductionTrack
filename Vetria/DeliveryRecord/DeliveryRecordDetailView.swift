
import SwiftUI
import Foundation

@available(iOS 14.0, *)
struct DeliveryRecordDetailView: View {
    let record: DeliveryRecord
    
    private let tealColor = Color(red: 0.1, green: 0.6, blue: 0.6)
    private let brownColor = Color(red: 0.6, green: 0.4, blue: 0.2)
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
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
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(record.deliveryNumber)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.white)
                        Text("\(record.startLocation) → \(record.destination)")
                            .font(.title3)
                            .foregroundColor(Color.white.opacity(0.9))
                    }
                    
                    Text(record.status.uppercased())
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(statusColor)
                        .cornerRadius(10)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    DeliveryRecordDetailSectionTitle(title: "Driver & Vehicle Info", icon: "car.fill")
                    
                    VStack(spacing: 5) {
                        DeliveryRecordDetailFieldRow(label: "Driver Name", value: record.driverName, iconName: "person.crop.square.fill")
                            .frame(maxWidth: .infinity)
                        DeliveryRecordDetailFieldRow(label: "Vehicle ID", value: record.vehicleID, iconName: "tag.circle.fill")
                            .frame(maxWidth: .infinity)
                        Divider()
                        
                        DeliveryRecordDetailFieldRow(label: "License Plate", value: record.licensePlate, iconName: "numberplate.fill")
                            .frame(maxWidth: .infinity)
                        DeliveryRecordDetailFieldRow(label: "Route Code", value: record.routeCode, iconName: "figure.walk")
                            .frame(maxWidth: .infinity)
                    }
                }
                .modifier(DeliveryRecordDetailGroupBoxModifier())
                
                VStack(alignment: .leading, spacing: 10) {
                    DeliveryRecordDetailSectionTitle(title: "Timing & Logistics", icon: "timer")
                    
                    VStack(spacing: 5) {
                        DeliveryRecordDetailFieldRow(label: "Start Date", value: formattedDate(record.startDate), iconName: "calendar.badge.clock", accentColor: .orange)
                            .frame(maxWidth: .infinity)
                        DeliveryRecordDetailFieldRow(label: "Delivery Date", value: formattedDate(record.deliveryDate), iconName: "calendar.badge.checkmark", accentColor: .orange)
                            .frame(maxWidth: .infinity)
                        
                        Divider()
                        DeliveryRecordDetailFieldRow(label: "Est. Time (Min)", value: "\(record.estimatedTimeMinutes)", iconName: "stopwatch.fill", accentColor: tealColor)
                            .frame(maxWidth: .infinity)
                        DeliveryRecordDetailFieldRow(label: "Actual Time (Min)", value: "\(record.actualTimeMinutes)", iconName: "clock.arrow.circlepath", accentColor: tealColor)
                            .frame(maxWidth: .infinity)
                        Divider()
                        
                        DeliveryRecordDetailFieldRow(label: "Distance (KM)", value: String(format: "%.1f", record.distanceKM), iconName: "road.lanes", accentColor: brownColor)
                        DeliveryRecordDetailFieldRow(label: "Fuel Used (L)", value: String(format: "%.2f", record.fuelUsedLiters), iconName: "fuelpump.fill", accentColor: brownColor)
                    }
                }
                .modifier(DeliveryRecordDetailGroupBoxModifier())
                
                VStack(alignment: .leading, spacing: 10) {
                    DeliveryRecordDetailSectionTitle(title: "Shipment Content & Condition", icon: "box.truck.fill")
                    
                    VStack(spacing: 5) {
                        HStack {
                            DeliveryRecordDetailFieldRow(label: "Package Count", value: "\(record.packageCount)", iconName: "cube.fill")
                                .frame(maxWidth: .infinity)
                            DeliveryRecordDetailFieldRow(label: "Fragile Items", value: "\(record.fragileItems)", iconName: "hand.raised.fill", accentColor: .red)
                                .frame(maxWidth: .infinity)
                        }
                        
                        DeliveryRecordDetailFieldRow(label: "Temperature Req.", value: record.temperatureRequirement, iconName: "thermometer.sun.fill")
                        
                        DeliveryRecordDetailFieldRow(label: "Is Delivered?", value: record.isDelivered ? "Yes" : "No", iconName: record.isDelivered ? "checkmark.circle.fill" : "xmark.circle.fill", accentColor: record.isDelivered ? .green : .red)
                    }
                }
                .modifier(DeliveryRecordDetailGroupBoxModifier())
                
                VStack(alignment: .leading, spacing: 10) {
                    DeliveryRecordDetailSectionTitle(title: "Confirmation & Feedback", icon: "pencil.and.outline")
                    
                    VStack(spacing: 5) {
                        DeliveryRecordDetailFieldRow(label: "Receiver Name", value: record.receiverName, iconName: "person.text.rectangle.fill")
                            .frame(maxWidth: .infinity)
                        DeliveryRecordDetailFieldRow(label: "Feedback Rating", value: "\(record.feedbackRating)/5", iconName: "star.fill", accentColor: .yellow)
                            .frame(maxWidth: .infinity)
                        
                        
                        DeliveryRecordDetailFieldRow(label: "Completion Code", value: record.completionCode, iconName: "lock.fill", accentColor: .gray)
                        DeliveryRecordDetailFieldRow(label: "Receiver Signature", value: record.receiverSignature.isEmpty ? "N/A" : record.receiverSignature, iconName: "signature", accentColor: .gray)
                        DeliveryRecordDetailFieldRow(label: "Issue Reported", value: record.issueReported ? "Yes" : "No", iconName: record.issueReported ? "exclamationmark.triangle.fill" : "hand.thumbsup.fill", accentColor: record.issueReported ? .red : .green)
                        
                        if record.issueReported {
                            DeliveryRecordDetailFieldRow(label: "Issue Details", value: record.issueDescription.isEmpty ? "No Details Provided" : record.issueDescription, iconName: "text.justify", accentColor: .red)
                        }
                    }
                }
                .modifier(DeliveryRecordDetailGroupBoxModifier())
                
                VStack(alignment: .leading, spacing: 10) {
                    DeliveryRecordDetailSectionTitle(title: "Additional Notes", icon: "doc.text")
                    
                    Text(record.deliveryNotes)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    DeliveryRecordDetailSectionTitle(title: "Tags", icon: "tag.slash.fill")
                    
                    Text(record.tags.joined(separator: ", "))
                        .font(.callout)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(5)
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
                
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

@available(iOS 14.0, *)
struct DeliveryRecordDetailSectionTitle: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}

@available(iOS 14.0, *)
struct DeliveryRecordDetailGroupBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
            .padding(.horizontal)
    }
}


@available(iOS 14.0, *)
struct DeliveryRecordDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    var accentColor: Color = Color.blue
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(accentColor)
                    .frame(width: 20)
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .padding(.vertical, 8)
    }
}
