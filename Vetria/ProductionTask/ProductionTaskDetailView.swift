
import SwiftUI
import Combine


@available(iOS 14.0, *)
struct ProductionTaskDetailView: View {
    let task: ProductionTask
    
    private func formattedArray(_ array: [String]) -> String {
        return array.isEmpty ? "N/A" : array.joined(separator: ", ")
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(task.title)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("Ref: \(task.referenceCode) | Stage: \(task.stage)")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.8))

                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("\(task.progressPercent)% Complete - \(task.status)")
                    }
                    .font(.body)
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color(red: 0.0, green: 0.8, blue: 0.9)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

                
                VStack(alignment: .leading, spacing: 5) {
                    ProductionTaskDetailGroupHeader(title: "Task Description", iconName: "note.text.badge.plus")
                    Text(task.description)
                        .font(.body)
                        .padding(.leading, 5)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    ProductionTaskDetailGroupHeader(title: "Assignment Details", iconName: "person.3.fill")
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            ProductionTaskDetailFieldRow(label: "Assigned To", value: task.assignedTo, iconName: "person.fill", accentColor: .blue)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Department", value: task.department, iconName: "building.2.fill", accentColor: .blue)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Supervisor", value: task.supervisorName, iconName: "eye.fill", accentColor: .blue)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Priority Level", value: task.priorityLevel, iconName: "flame.fill", accentColor: .red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ProductionTaskDetailFieldRow(label: "Created Date", value: task.createdDate.formattedDate(), iconName: "doc.badge.plus", accentColor: .gray)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Last Updated", value: task.lastUpdated.formattedTime(), iconName: "arrow.uturn.right.circle.fill", accentColor: .gray)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Due Date", value: task.dueDate.formattedDate(), iconName: "calendar.badge.clock", accentColor: .purple)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Delay Reason", value: task.delayReason, iconName: "bolt.fill", accentColor: .red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    ProductionTaskDetailGroupHeader(title: "Time & Cost Metrics", iconName: "timer")

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            ProductionTaskDetailFieldRow(label: "Start Time", value: task.startTime.formattedTime(), iconName: "play.circle.fill", accentColor: .purple)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "End Time", value: task.endTime.formattedTime(), iconName: "stop.circle.fill", accentColor: .purple)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Time Spent (Min)", value: "\(task.timeSpentMinutes)", iconName: "clock.arrow.circlepath", accentColor: .purple)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Cost Estimate", value: String(format: "$%.2f", task.costEstimate), iconName: "dollarsign.circle.fill", accentColor: .purple)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ProductionTaskDetailFieldRow(label: "Approval Required", value: task.approvalRequired ? "Yes" : "No", iconName: "hand.raised.fill", accentColor: .teal14)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Approval Status", value: task.approvalStatus, iconName: "seal.fill", accentColor: .teal14)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Safety Compliance", value: task.safetyCompliance ? "Compliant" : "Non-Compliant", iconName: "bandage.fill", accentColor: task.safetyCompliance ? .green : .red)
                            Divider()
                            ProductionTaskDetailFieldRow(label: "Outcome Summary", value: task.outcome, iconName: "flag.checkered.2.fill", accentColor: .green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 10) {
                    ProductionTaskDetailGroupHeader(title: "General Review", iconName: "doc.text.fill")
                    Divider()
                    ProductionTaskDetailFieldRow(label: "Required Tools", value: formattedArray(task.requiredTools), iconName: "wrench.and.screwdriver.fill", accentColor: .brown14)
                    Divider()
                    ProductionTaskDetailFieldRow(label: "Tags", value: formattedArray(task.tags), iconName: "tag.fill", accentColor: .brown14)
                    Divider()
                    ProductionTaskDetailFieldRow(label: "Remarks/Notes", value: task.remarks, iconName: "note.text", accentColor: .blue)
                }
                .padding(.horizontal)
            }.padding(.horizontal,20)
            .padding(.bottom, 30)
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}



@available(iOS 14.0, *)
extension Color {
    static let teal14 = Color(red: 0.0, green: 0.5, blue: 0.5)
    static let brown14 = Color(red: 0.65, green: 0.16, blue: 0.16)
}

@available(iOS 14.0, *)
extension Date {

    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}


@available(iOS 14.0, *)
struct ProductionTaskDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(accentColor)
                    .frame(width: 20)
                
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .padding(.leading, 28)
        }
        .padding(.vertical, 5)
    }
}

@available(iOS 14.0, *)
struct ProductionTaskDetailGroupHeader: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
        }
        .foregroundColor(.primary)
        .padding(.top, 10)
    }
}
