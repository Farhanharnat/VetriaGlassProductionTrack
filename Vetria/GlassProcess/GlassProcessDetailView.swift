
import SwiftUI
import Foundation

@available(iOS 14.0, *)
struct GlassProcessDetailView: View {
    let process: GlassProcess
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func detailSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
            
            VStack(spacing: 0) {
                content()
            }
            .padding(15)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding(.horizontal)
        .padding(.bottom, 15)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(process.title)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text(process.description)
                        .font(.title3)
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    HStack {
                        Image(systemName: "tag.square.fill")
                        Text(process.batchNumber)
                    }
                    .foregroundColor(.white)
                    .font(.subheadline)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(radius: 5)
                .cornerRadius(20)
                .padding(.horizontal)
                
                detailSection(title: "Technical Specifications", icon: "gearshape.fill") {
                    VStack(spacing: 8) {
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.processType).1, label: GlassProcess.label(for: \.processType).0, value: process.processType)
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.temperature).1, label: GlassProcess.label(for: \.temperature).0, value: process.temperature)
                        }
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.durationMinutes).1, label: GlassProcess.label(for: \.durationMinutes).0, value: "\(process.durationMinutes) min")
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.pressureLevel).1, label: GlassProcess.label(for: \.pressureLevel).0, value: process.pressureLevel)
                        }
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.toolUsed).1, label: GlassProcess.label(for: \.toolUsed).0, value: process.toolUsed)
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.stage).1, label: GlassProcess.label(for: \.stage).0, value: process.stage)
                        }
                    }
                }
                
                detailSection(title: "Quality and Metrics", icon: "chart.bar.fill") {
                    VStack(spacing: 8) {
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.qualityCheckStatus).1, label: GlassProcess.label(for: \.qualityCheckStatus).0, value: process.qualityCheckStatus)
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.clarityRating).1, label: GlassProcess.label(for: \.clarityRating).0, value: process.clarityRating)
                        }
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.thicknessMM).1, label: GlassProcess.label(for: \.thicknessMM).0, value: "\(process.thicknessMM) mm")
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.colorType).1, label: GlassProcess.label(for: \.colorType).0, value: process.colorType)
                        }
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.energyUsedKWh).1, label: GlassProcess.label(for: \.energyUsedKWh).0, value: String(format: "%.2f kWh", process.energyUsedKWh))
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.wastagePercent).1, label: GlassProcess.label(for: \.wastagePercent).0, value: String(format: "%.2f%%", process.wastagePercent))
                        }
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.humidityLevel).1, label: GlassProcess.label(for: \.humidityLevel).0, value: process.humidityLevel)
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.resultCode).1, label: GlassProcess.label(for: \.resultCode).0, value: process.resultCode)
                        }
                    }
                }
                
                detailSection(title: "Personnel and Admin", icon: "person.3.fill") {
                    VStack(spacing: 8) {
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.supervisor).1, label: GlassProcess.label(for: \.supervisor).0, value: process.supervisor)
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.location).1, label: GlassProcess.label(for: \.location).0, value: process.location)
                        }
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.approvalStatus).1, label: GlassProcess.label(for: \.approvalStatus).0, value: process.approvalStatus)
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.safetyLevel).1, label: GlassProcess.label(for: \.safetyLevel).0, value: process.safetyLevel)
                        }
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.maintenanceNeeded).1, label: GlassProcess.label(for: \.maintenanceNeeded).0, value: process.maintenanceNeeded ? "Yes (Maintenance Required)" : "No (Maintenance OK)")
                        }
                    }
                }
                
                detailSection(title: "Notes and Dates", icon: "calendar.badge.clock") {
                    VStack(spacing: 8) {
                        GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.tags).1, label: GlassProcess.label(for: \.tags).0, value: process.tags.joined(separator: ", "))
                        GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.notes).1, label: GlassProcess.label(for: \.notes).0, value: process.notes)
                        
                        HStack(alignment: .top) {
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.dateCreated).1, label: GlassProcess.label(for: \.dateCreated).0, value: formattedDate(process.dateCreated))
                            Divider()
                            GlassProcessDetailFieldRow(icon: GlassProcess.label(for: \.lastModified).1, label: GlassProcess.label(for: \.lastModified).0, value: formattedDate(process.lastModified))
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Process Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


@available(iOS 14.0, *)
struct GlassProcessDetailFieldRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}
