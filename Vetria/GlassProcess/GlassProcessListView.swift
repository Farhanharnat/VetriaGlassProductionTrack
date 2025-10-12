
import SwiftUI

@available(iOS 14.0, *)
struct GlassProcessListView: View {
    @EnvironmentObject var dataStore: GlassDataStore
    @State private var showingAddView = false
    @State private var searchText = ""
    
    private var filteredProcesses: [GlassProcess] {
        if searchText.isEmpty {
            return dataStore.processes
        } else {
            return dataStore.processes.filter { process in
                process.title.localizedCaseInsensitiveContains(searchText) ||
                process.batchNumber.localizedCaseInsensitiveContains(searchText) ||
                process.supervisor.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func deleteProcess(at offsets: IndexSet) {
        offsets.map { filteredProcesses[$0].id }.forEach { id in
            dataStore.deleteProcess(id)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            GlassProcessSearchBarView(searchText: $searchText)
            
            if filteredProcesses.isEmpty {
                GlassProcessNoDataView()
                Spacer()
            } else {
                List {
                    ForEach(filteredProcesses) { process in
                        NavigationLink(destination: GlassProcessDetailView(process: process)) {
                            GlassProcessListRowView(process: process)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteProcess)
                }
                .listStyle(PlainListStyle())
            }
        }
            .navigationTitle("Process Log")
            .navigationBarItems(trailing:
                                    Button(action: {
                showingAddView = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            )
            .sheet(isPresented: $showingAddView) {
                GlassProcessAddView()
                    .environmentObject(dataStore)
            }
    }
}

@available(iOS 14.0, *)
struct GlassProcessSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .gray : .blue)
                .padding(.leading, 8)
                .scaleEffect(searchText.isEmpty ? 1.0 : 1.1)
            
            TextField("Search Processes...", text: $searchText)
                .padding(.vertical, 10)
                .padding(.trailing, 8)
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
        .background(Color(.systemGray5))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .animation(.default)
    }
}

@available(iOS 14.0, *)
struct GlassProcessListRowView: View {
    let process: GlassProcess
    
     struct KeyValueView: View {
        let icon: String
        let label: String
        let value: String
        let color: Color
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundColor(color)
                Text("\(label):")
                    .font(.caption2)
                    .fontWeight(.medium)
                Text(value)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(process.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(process.processType)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                Spacer()
                
                Text(process.stage)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.1, green: 0.5, blue: 0.2))
                    .cornerRadius(6)
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray4))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    KeyValueView(icon: "thermometer", label: "Temp", value: process.temperature, color: Color.red)
                    Spacer()
                    KeyValueView(icon: "clock", label: "Dur", value: "\(process.durationMinutes) min", color: Color.orange)
                }
                
                Divider()
                HStack{
                    KeyValueView(icon: "gauge", label: "Press", value: process.pressureLevel, color: Color.yellow)
                    Spacer()
                    KeyValueView(icon: "hand.thumbsup", label: "Approval", value: process.approvalStatus, color: process.approvalStatus == "Approved" ? Color.green : Color.red)
                }
                
                Divider()
                
                HStack {
                    KeyValueView(icon: "ruler", label: "Thick", value: "\(process.thicknessMM)mm", color: Color.gray)
                    Spacer()
                    KeyValueView(icon: "location.circle", label: "Loc", value: process.location, color: Color.blue)
                    
                }
                
                Divider()
                
                HStack {
                    KeyValueView(icon: "bolt", label: "Energy", value: String(format: "%.1f kWh", process.energyUsedKWh), color: Color.purple)
                    Spacer()
                    KeyValueView(icon: "trash", label: "Waste", value: String(format: "%.1f%%", process.wastagePercent), color: Color.pink)

                }
                
                Divider()
                
                HStack{
                    KeyValueView(icon: "staroflife", label: "Q.Status", value: process.qualityCheckStatus, color: Color.green)
                    Spacer()
                    KeyValueView(icon: "calendar", label: "Created", value: process.dateCreated, color: Color.black)
                    
                }
                
                Divider()
                
                HStack {
                    KeyValueView(icon: "person.crop.square", label: "Sup", value: process.supervisor, color: Color.init(red: 0.5, green: 0.25, blue: 0))
                    Spacer()
                    KeyValueView(icon: "tag", label: "Batch", value: process.batchNumber, color: Color.init(red: 0.2, green: 0.8, blue: 0.8))

                }
                
                
                Divider()
                
                HStack {
                    KeyValueView(icon: "sparkle", label: "Clarity", value: process.clarityRating, color: Color.yellow)
                    Spacer()
                    KeyValueView(icon: "paintpalette", label: "Color", value: process.colorType, color: Color.pink)
                }
                Divider()
            }
            
            Text("Tags: \(process.tags.joined(separator: ", "))")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.top, 4)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 5)
        .padding(.horizontal, 8)
    }
}

@available(iOS 14.0, *)
extension GlassProcessListRowView.KeyValueView {
    init(icon: String, label: String, value: Date, color: Color) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        self.init(icon: icon, label: label, value: formatter.string(from: value), color: color)
    }
}

@available(iOS 14.0, *)
struct GlassProcessNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "archivebox.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray.opacity(0.5))
            
            Text("No Glass Processes Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Text("Looks like the production log is empty. Tap the '+' button to record a new process.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}
