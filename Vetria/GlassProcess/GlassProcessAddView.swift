
import SwiftUI


@available(iOS 14.0, *)
struct GlassProcessAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: GlassDataStore
    
    @State private var id = UUID()
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var processType: String = ""
    @State private var temperature: String = ""
    @State private var durationMinutes: String = ""
    @State private var pressureLevel: String = ""
    @State private var toolUsed: String = ""
    @State private var supervisor: String = ""
    @State private var batchNumber: String = ""
    @State private var dateCreated: Date = Date()
    @State private var lastModified: Date = Date()
    @State private var stage: String = ""
    @State private var safetyLevel: String = ""
    @State private var notes: String = ""
    @State private var qualityCheckStatus: String = ""
    @State private var energyUsedKWh: String = ""
    @State private var wastagePercent: String = ""
    @State private var colorType: String = ""
    @State private var thicknessMM: String = ""
    @State private var clarityRating: String = ""
    @State private var humidityLevel: String = ""
    @State private var resultCode: String = ""
    @State private var location: String = ""
    @State private var approvalStatus: String = ""
    @State private var maintenanceNeeded: Bool = false
    @State private var tags: String = ""
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if title.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Title is required.") }
        if processType.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Process Type is required.") }
        if temperature.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Temperature is required.") }
        if pressureLevel.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Pressure Level is required.") }
        if toolUsed.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Tool Used is required.") }
        if supervisor.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Supervisor is required.") }
        if batchNumber.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Batch Number is required.") }
        if stage.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Stage is required.") }
        if safetyLevel.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Safety Level is required.") }
        if qualityCheckStatus.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Quality Status is required.") }
        if colorType.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Color Type is required.") }
        if clarityRating.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Clarity Rating is required.") }
        if humidityLevel.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Humidity Level is required.") }
        if resultCode.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Result Code is required.") }
        if location.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Location is required.") }
        if approvalStatus.trimmingCharacters(in: .whitespaces).isEmpty { errors.append("Approval Status is required.") }

        if durationMinutes.isEmpty || Int(durationMinutes) == nil { errors.append("Duration must be a valid number.") }
        if energyUsedKWh.isEmpty || Double(energyUsedKWh) == nil { errors.append("Energy Used must be a valid number.") }
        if wastagePercent.isEmpty || Double(wastagePercent) == nil { errors.append("Wastage % must be a valid number.") }
        if thicknessMM.isEmpty || Double(thicknessMM) == nil { errors.append("Thickness (mm) must be a valid number.") }
        
        if errors.isEmpty {
            let newProcess = GlassProcess(
                id: id,
                title: title,
                description: description,
                processType: processType,
                temperature: temperature,
                durationMinutes: Int(durationMinutes) ?? 0,
                pressureLevel: pressureLevel,
                toolUsed: toolUsed,
                supervisor: supervisor,
                batchNumber: batchNumber,
                dateCreated: dateCreated,
                lastModified: Date(),
                stage: stage,
                safetyLevel: safetyLevel,
                notes: notes,
                qualityCheckStatus: qualityCheckStatus,
                energyUsedKWh: Double(energyUsedKWh) ?? 0.0,
                wastagePercent: Double(wastagePercent) ?? 0.0,
                colorType: colorType,
                thicknessMM: Double(thicknessMM) ?? 0.0,
                clarityRating: clarityRating,
                humidityLevel: humidityLevel,
                resultCode: resultCode,
                location: location,
                approvalStatus: approvalStatus,
                maintenanceNeeded: maintenanceNeeded,
                tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            )
            
            dataStore.addProcess(newProcess)
            
            alertTitle = "Success! 🎉"
            alertMessage = "New process '\(newProcess.title)' was added successfully."
            showAlert = true
        } else {
            alertTitle = "Validation Errors"
            alertMessage = "Please correct the following issues:\n• " + errors.joined(separator: "\n• ")
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 15) {
                        GlassProcessAddSectionHeaderView(title: "Primary Details", iconName: "star.fill")
                        
                        GlassProcessAddFieldView(title: GlassProcess.label(for: \.title).0, iconName: GlassProcess.label(for: \.title).1, placeholder: "Process Title*", text: $title)
                        GlassProcessAddFieldView(title: GlassProcess.label(for: \.description).0, iconName: GlassProcess.label(for: \.description).1, placeholder: "Brief Description", text: $description)
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.processType).0, iconName: GlassProcess.label(for: \.processType).1, placeholder: "Type*", text: $processType)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.batchNumber).0, iconName: GlassProcess.label(for: \.batchNumber).1, placeholder: "Batch No.*", text: $batchNumber)
                        }
                    }
                    .padding(.top)
                    
                    Rectangle().frame(height: 1).foregroundColor(Color(.systemGray5)).padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        GlassProcessAddSectionHeaderView(title: "Technical Specs", iconName: "ruler.fill")
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.temperature).0, iconName: GlassProcess.label(for: \.temperature).1, placeholder: "Temperature*", text: $temperature)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.pressureLevel).0, iconName: GlassProcess.label(for: \.pressureLevel).1, placeholder: "Pressure Level*", text: $pressureLevel)
                        }
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.durationMinutes).0, iconName: GlassProcess.label(for: \.durationMinutes).1, placeholder: "Duration (Minutes)*", text: $durationMinutes, isNumber: true)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.thicknessMM).0, iconName: GlassProcess.label(for: \.thicknessMM).1, placeholder: "Thickness (mm)*", text: $thicknessMM, isNumber: true)
                        }
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.toolUsed).0, iconName: GlassProcess.label(for: \.toolUsed).1, placeholder: "Tool Used*", text: $toolUsed)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.location).0, iconName: GlassProcess.label(for: \.location).1, placeholder: "Location*", text: $location)
                        }
                    }
                    
                    Rectangle().frame(height: 1).foregroundColor(Color(.systemGray5)).padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        GlassProcessAddSectionHeaderView(title: "Quality and Status", iconName: "list.bullet.clipboard.fill")
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.clarityRating).0, iconName: GlassProcess.label(for: \.clarityRating).1, placeholder: "Clarity Rating*", text: $clarityRating)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.qualityCheckStatus).0, iconName: GlassProcess.label(for: \.qualityCheckStatus).1, placeholder: "Quality Status*", text: $qualityCheckStatus)
                        }
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.colorType).0, iconName: GlassProcess.label(for: \.colorType).1, placeholder: "Color Type*", text: $colorType)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.humidityLevel).0, iconName: GlassProcess.label(for: \.humidityLevel).1, placeholder: "Humidity Level*", text: $humidityLevel)
                        }
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.resultCode).0, iconName: GlassProcess.label(for: \.resultCode).1, placeholder: "Result Code*", text: $resultCode)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.approvalStatus).0, iconName: GlassProcess.label(for: \.approvalStatus).1, placeholder: "Approval Status*", text: $approvalStatus)
                        }
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.safetyLevel).0, iconName: GlassProcess.label(for: \.safetyLevel).1, placeholder: "Safety Level*", text: $safetyLevel)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.stage).0, iconName: GlassProcess.label(for: \.stage).1, placeholder: "Production Stage*", text: $stage)
                        }
                        
                        GlassProcessAddToggleFieldView(title: GlassProcess.label(for: \.maintenanceNeeded).0, iconName: GlassProcess.label(for: \.maintenanceNeeded).1, isOn: $maintenanceNeeded)
                    }
                    
                    Rectangle().frame(height: 1).foregroundColor(Color(.systemGray5)).padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        GlassProcessAddSectionHeaderView(title: "Metrics and Personnel", iconName: "person.3.fill")
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.energyUsedKWh).0, iconName: GlassProcess.label(for: \.energyUsedKWh).1, placeholder: "Energy (kWh)*", text: $energyUsedKWh, isNumber: true)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.wastagePercent).0, iconName: GlassProcess.label(for: \.wastagePercent).1, placeholder: "Wastage %*", text: $wastagePercent, isNumber: true)
                        }
                        
                        HStack(spacing: 10) {
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.supervisor).0, iconName: GlassProcess.label(for: \.supervisor).1, placeholder: "Supervisor*", text: $supervisor)
                            GlassProcessAddFieldView(title: GlassProcess.label(for: \.tags).0, iconName: GlassProcess.label(for: \.tags).1, placeholder: "Tags (comma-separated)", text: $tags)
                        }
                        
                        GlassProcessAddFieldView(title: GlassProcess.label(for: \.notes).0, iconName: GlassProcess.label(for: \.notes).1, placeholder: "Additional Notes", text: $notes)
                        
                        GlassProcessAddDatePickerView(title: GlassProcess.label(for: \.dateCreated).0, iconName: GlassProcess.label(for: \.dateCreated).1, date: $dateCreated)
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: validateAndSave) {
                        Text("Record New GlassProcess")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("New Process Record")
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertTitle == "Success! 🎉" {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
}



@available(iOS 14.0, *)
extension GlassProcess {
    static func label(for keyPath: PartialKeyPath<GlassProcess>) -> (String, String) {
        let keyString: String
        
        switch keyPath {
        case \GlassProcess.title: keyString = "Title"; return (keyString, "text.badge.checkmark")
        case \GlassProcess.description: keyString = "Description"; return (keyString, "note.text")
        case \GlassProcess.processType: keyString = "Process Type"; return (keyString, "gearshape.2")
        case \GlassProcess.temperature: keyString = "Temperature"; return (keyString, "thermometer")
        case \GlassProcess.durationMinutes: keyString = "Duration (min)"; return (keyString, "clock")
        case \GlassProcess.pressureLevel: keyString = "Pressure Level"; return (keyString, "gauge")
        case \GlassProcess.toolUsed: keyString = "Tool Used"; return (keyString, "wrench.and.screwdriver")
        case \GlassProcess.supervisor: keyString = "Supervisor"; return (keyString, "person.crop.square")
        case \GlassProcess.batchNumber: keyString = "Batch Number"; return (keyString, "tag")
        case \GlassProcess.dateCreated: keyString = "Date Created"; return (keyString, "calendar.badge.plus")
        case \GlassProcess.lastModified: keyString = "Last Modified"; return (keyString, "pencil.and.ruler")
        case \GlassProcess.stage: keyString = "Stage"; return (keyString, "chart.bar")
        case \GlassProcess.safetyLevel: keyString = "Safety Level"; return (keyString, "cross.case")
        case \GlassProcess.notes: keyString = "Notes"; return (keyString, "note.text")
        case \GlassProcess.qualityCheckStatus: keyString = "Quality Status"; return (keyString, "staroflife")
        case \GlassProcess.energyUsedKWh: keyString = "Energy Used (kWh)"; return (keyString, "bolt")
        case \GlassProcess.wastagePercent: keyString = "Wastage (%)"; return (keyString, "trash")
        case \GlassProcess.colorType: keyString = "Color Type"; return (keyString, "paintpalette")
        case \GlassProcess.thicknessMM: keyString = "Thickness (mm)"; return (keyPath == \GlassProcess.thicknessMM) ? ("Thickness (mm)", "ruler") : ("Thickness (mm)", "ruler")
        case \GlassProcess.clarityRating: keyString = "Clarity Rating"; return (keyString, "sparkle")
        case \GlassProcess.humidityLevel: keyString = "Humidity Level"; return (keyString, "humidity")
        case \GlassProcess.resultCode: keyString = "Result Code"; return (keyString, "barcode")
        case \GlassProcess.location: keyString = "Location"; return (keyString, "location.circle")
        case \GlassProcess.approvalStatus: keyString = "Approval Status"; return (keyString, "hand.thumbsup")
        case \GlassProcess.maintenanceNeeded: keyString = "Maintenance Needed"; return (keyString, "screwdriver")
        case \GlassProcess.tags: keyString = "Tags"; return (keyString, "folder.fill")
        default: return ("Unknown", "questionmark.circle")
        }
    }
}

@available(iOS 14.0, *)
struct GlassProcessAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

@available(iOS 14.0, *)
struct GlassProcessAddFieldView: View {
    let title: String
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var isNumber: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !text.isEmpty {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .transition(.opacity)
            }
            
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                TextField(text.isEmpty ? placeholder : "", text: $text)
                    .keyboardType(isNumber ? .decimalPad : .default)
            }
            .padding(.vertical, 10)
            
            Divider()
                .background(Color.gray.opacity(0.5))
        }
        .padding(.horizontal)
        .animation(.easeOut(duration: 0.15))
    }
}

@available(iOS 14.0, *)
struct GlassProcessAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            GlassProcessAddSectionHeaderView(title: title, iconName: iconName)
            HStack {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

@available(iOS 14.0, *)
struct GlassProcessAddToggleFieldView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle())
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
