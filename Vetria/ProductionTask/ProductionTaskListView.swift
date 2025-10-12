
import SwiftUI

@available(iOS 14.0, *)
struct ProductionTaskListView: View {
    @EnvironmentObject var dataStore: GlassDataStore
    @State private var searchText: String = ""
    
    var filteredTasks: [ProductionTask] {
        if searchText.isEmpty {
            return dataStore.tasks
        } else {
            return dataStore.tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                task.assignedTo.localizedCaseInsensitiveContains(searchText) ||
                task.referenceCode.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
            VStack {
                ProductionTaskSearchBarView(searchText: $searchText)
                    .padding(.top, 8)
                
                if filteredTasks.isEmpty {
                    ProductionTaskNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredTasks) { task in
                            NavigationLink(destination: ProductionTaskDetailView(task: task)) {
                                ProductionTaskListRowView(task: task)
                                    .padding(.vertical, 5)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .background(Color.clear)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Production Tasks")
            .navigationBarItems(trailing:
                                    NavigationLink(destination: ProductionTaskAddView().environmentObject(dataStore)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


@available(iOS 14.0, *)
struct ProductionTaskSearchBarView: View {
    @Binding var searchText: String
    @State private var isSearching: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(isSearching ? .blue : .gray)
                
                TextField("Search tasks...", text: $searchText, onEditingChanged: { isEditing in
                    withAnimation {
                        self.isSearching = isEditing || !self.searchText.isEmpty
                    }
                })
                .foregroundColor(.primary)
                .padding(.vertical, 8)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        withAnimation {
                            self.isSearching = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSearching ? Color.blue : Color.clear, lineWidth: 1)
            )
            .animation(.spring(), value: isSearching)
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct ProductionTaskListRowView: View {
    let task: ProductionTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text(task.assignedTo)
                        Text("|")
                        Image(systemName: "building.2.fill")
                        Text(task.department)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(task.status)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor(task.status).opacity(0.15))
                        .foregroundColor(statusColor(task.status))
                        .cornerRadius(6)
                    
                    Text(task.approvalStatus)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.1))
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    DetailItem(icon: "calendar.badge.clock", label: "Due", value: task.dueDate.formattedDate())
                    DetailItem(icon: "chart.pie.fill", label: "Progress", value: "\(task.progressPercent)%")
                    DetailItem(icon: "clock.fill", label: "Time Spent", value: "\(task.timeSpentMinutes)m")
                    DetailItem(icon: "dollarsign.circle", label: "Cost Est.", value: String(format: "$%.2f", task.costEstimate))
                    DetailItem(icon: "wrench.and.screwdriver.fill", label: "Tools", value: formattedArray(task.requiredTools))
                    DetailItem(icon: "note.text", label: "Remarks", value: task.remarks)
                    DetailItem(icon: "exclamationmark.triangle.fill", label: "Delay", value: task.delayReason)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    DetailItem(icon: "number.square", label: "Ref Code", value: task.referenceCode)
                    DetailItem(icon: "hand.raised.fill", label: "Apprvl Req.", value: task.approvalRequired ? "Yes" : "No")
                    DetailItem(icon: "hammer.fill", label: "Stage", value: task.stage)
                    DetailItem(icon: "arrow.uturn.right.circle.fill", label: "Last Upd.", value: task.lastUpdated.formattedTime())
                    DetailItem(icon: "bandage.fill", label: "Safety", value: task.safetyCompliance ? "Compliant" : "Non-Compliant")
                    DetailItem(icon: "flag.checkered.2.fill", label: "Outcome", value: task.outcome)
                    DetailItem(icon: "eye.fill", label: "Supervisor", value: task.supervisorName)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.caption)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    ForEach(task.tags.prefix(3), id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                Text(task.description)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }
            .padding(.top, 5)
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 10)
    }
    
    private struct DetailItem: View {
        let icon: String
        let label: String
        let value: String
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 15)
                Text("**\(label):** \(value)")
                    .lineLimit(1)
            }
        }
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Completed": return .green
        case "In Progress": return .orange
        case "High": return .red
        default: return .blue
        }
    }
    
    private func formattedArray(_ array: [String]) -> String {
        return array.isEmpty ? "N/A" : array.prefix(1).joined(separator: ", ")
    }
}

@available(iOS 14.0, *)
struct ProductionTaskNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
                .opacity(0.5)
            
            Text("No Production Tasks Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("It looks like you haven't added any tasks yet, or your search didn't match. Tap the '+' button to get started!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}
