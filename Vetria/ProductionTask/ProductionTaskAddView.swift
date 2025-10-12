
import SwiftUI

@available(iOS 14.0, *)
struct ProductionTaskAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: GlassDataStore

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var assignedTo: String = ""
    @State private var department: String = ""
    @State private var priorityLevel: String = "Medium"
    @State private var dueDate: Date = Date().addingTimeInterval(86400)
    @State private var createdDate: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    @State private var status: String = "Scheduled"
    @State private var progressPercent: String = "0"
    @State private var timeSpentMinutes: String = "0"
    @State private var requiredTools: String = ""
    @State private var safetyCompliance: Bool = true
    @State private var remarks: String = ""
    @State private var supervisorName: String = ""
    @State private var costEstimate: String = "0.0"
    @State private var approvalRequired: Bool = false
    @State private var approvalStatus: String = "Pending"
    @State private var delayReason: String = "None"
    @State private var stage: String = "Initial"
    @State private var outcome: String = "N/A"
    @State private var lastUpdated: Date = Date()
    @State private var referenceCode: String = ""
    @State private var tags: String = ""

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    private let priorityLevels = ["High", "Medium", "Low"]
    private let statusOptions = ["Scheduled", "In Progress", "Completed", "On Hold"]
    private let approvalOptions = ["Pending", "Approved", "Rejected", "N/A"]

    func validateAndSave() {
        var errors: [String] = []

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Title is required.") }
        if assignedTo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Assignee is required.") }
        if department.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Department is required.") }
        if referenceCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Reference Code is required.") }
        if let progress = Int(progressPercent), !(0...100).contains(progress) { errors.append("Progress must be between 0 and 100.") }
        if Double(costEstimate) == nil { errors.append("Cost Estimate must be a valid number.") }
        if Int(timeSpentMinutes) == nil { errors.append("Time Spent must be a valid integer.") }


        if errors.isEmpty {
            let newTask = ProductionTask(
                id: UUID(),
                title: title,
                description: description,
                assignedTo: assignedTo,
                department: department,
                priorityLevel: priorityLevel,
                dueDate: dueDate,
                createdDate: Date(),
                startTime: startTime,
                endTime: endTime,
                status: status,
                progressPercent: Int(progressPercent) ?? 0,
                timeSpentMinutes: Int(timeSpentMinutes) ?? 0,
                requiredTools: requiredTools.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) },
                safetyCompliance: safetyCompliance,
                remarks: remarks,
                supervisorName: supervisorName,
                costEstimate: Double(costEstimate) ?? 0.0,
                approvalRequired: approvalRequired,
                approvalStatus: approvalStatus,
                delayReason: delayReason,
                stage: stage,
                outcome: outcome,
                lastUpdated: Date(),
                referenceCode: referenceCode,
                tags: tags.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            )
            
            dataStore.addTask(newTask)
            
            alertMessage = "✅ Task Added Successfully!\nTitle: \(title)"
            presentationMode.wrappedValue.dismiss()

        } else {
            alertMessage = "❌ **Validation Failed:**\n" + errors.joined(separator: "\n")
        }
        showAlert = true
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 15) {
                        ProductionTaskAddSectionHeaderView(title: "Core Task Details", iconName: "list.bullet.rectangle.portrait")
                        
                        HStack(spacing: 15) {
                            ProductionTaskAddFieldView(title: "Title (Required)", iconName: "hammer.fill", text: $title)
                                .frame(maxWidth: .infinity)
                            ProductionTaskAddFieldView(title: "Reference Code (Required)", iconName: "number.square.fill", text: $referenceCode)
                                .frame(maxWidth: .infinity)
                        }
                        
                        ProductionTaskAddFieldView(title: "Description", iconName: "text.alignleft", text: $description)
                        
                        HStack(spacing: 15) {
                            ProductionTaskAddFieldView(title: "Assigned To (Required)", iconName: "person.fill", text: $assignedTo)
                            ProductionTaskAddFieldView(title: "Supervisor", iconName: "eye.fill", text: $supervisorName)
                        }
                        
                        ProductionTaskAddFieldView(title: "Department (Required)", iconName: "building.2.fill", text: $department)

                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        ProductionTaskAddSectionHeaderView(title: "Scheduling & Time", iconName: "clock.fill")
                        
                        ProductionTaskAddDatePickerView(title: "Due Date", iconName: "calendar", date: $dueDate)
                        
                        VStack(spacing: 15) {
                            ProductionTaskAddDatePickerView(title: "Start Time", iconName: "play.circle.fill", date: $startTime)
                            ProductionTaskAddDatePickerView(title: "End Time", iconName: "stop.circle.fill", date: $endTime)
                        }

                        ProductionTaskAddFieldView(title: "Time Spent (Minutes)", iconName: "timer", text: $timeSpentMinutes)
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        ProductionTaskAddSectionHeaderView(title: "Status & Metrics", iconName: "chart.bar.fill")
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Status:")
                                    .fontWeight(.medium)
                                Spacer()
                                Picker("Status", selection: $status) {
                                    ForEach(statusOptions, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            
                            HStack {
                                Text("Priority Level:")
                                    .fontWeight(.medium)
                                Spacer()
                                Picker("Priority Level", selection: $priorityLevel) {
                                    ForEach(priorityLevels, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            
                            HStack {
                                Text("Approval Status:")
                                    .fontWeight(.medium)
                                Spacer()
                                Picker("Approval Status", selection: $approvalStatus) {
                                    ForEach(approvalOptions, id: \.self) { Text($0) }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            
                            ProductionTaskAddFieldView(title: "Progress (%) (0-100)", iconName: "percent", text: $progressPercent)
                                .keyboardType(.numberPad)
                            
                            ProductionTaskAddFieldView(title: "Current Stage", iconName: "arrow.triangle.branch", text: $stage)
                            
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)
                        
                        ProductionTaskAddFieldView(title: "Cost Estimate (\(Locale.current.currencySymbol ?? "$"))", iconName: "dollarsign.circle.fill", text: $costEstimate)
                            .keyboardType(.decimalPad)

                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        ProductionTaskAddSectionHeaderView(title: "Tools & Review", iconName: "wrench.and.screwdriver.fill")
                        
                        ProductionTaskAddFieldView(title: "Required Tools (Comma-separated)", iconName: "wrench.fill", text: $requiredTools)
                        
                        HStack {
                            Toggle(isOn: $safetyCompliance) {
                                Text("Safety Compliant")
                            }
                            .accentColor(.green)
                            
                            Toggle(isOn: $approvalRequired) {
                                Text("Approval Required")
                            }
                            .accentColor(.orange)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(10)

                        ProductionTaskAddFieldView(title: "Remarks/Notes", iconName: "note.text", text: $remarks)
                        ProductionTaskAddFieldView(title: "Delay Reason (If any)", iconName: "exclamationmark.triangle.fill", text: $delayReason)
                        ProductionTaskAddFieldView(title: "Outcome Summary", iconName: "flag.checkered.2.fill", text: $outcome)
                        ProductionTaskAddFieldView(title: "Tags (Comma-separated)", iconName: "tag.fill", text: $tags)
                        
                        ProductionTaskAddDatePickerView(title: "Created Date", iconName: "calendar.badge.plus", date: $createdDate)
                        ProductionTaskAddDatePickerView(title: "Last Updated", iconName: "arrow.uturn.right.circle.fill", date: $lastUpdated)
                    }
                    .padding(.horizontal)
                    
                    Button(action: validateAndSave) {
                        Text("Create New Production Task")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.accentColor]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("New Production Task")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Task Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 14.0, *)
struct ProductionTaskAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    @State private var isEditing: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.blue)
                    .font(.caption)
                    .offset(y: -25)
                    .scaleEffect(1, anchor: .leading)
                    .animation(.spring(), value: text.isEmpty)
                
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $text, onEditingChanged: { isEditing = $0 })
                        .padding(.leading, 5)
                        .padding(.top, 10)
                }
            }
            .padding(.top, 10)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isEditing ? Color.blue : Color.gray.opacity(0.3))
        }
    }
}

@available(iOS 14.0, *)
struct ProductionTaskAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            DatePicker("", selection: $date)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct ProductionTaskAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.blue)
        .cornerRadius(8)
    }
}


