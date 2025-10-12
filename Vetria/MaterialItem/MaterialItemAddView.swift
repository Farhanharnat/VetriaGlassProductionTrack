
import SwiftUI

@available(iOS 14.0, *)
struct MaterialItemAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataStore: GlassDataStore
    
    @State private var name: String = ""
    @State private var code: String = ""
    @State private var category: String = ""
    @State private var subCategory: String = ""
    @State private var supplier: String = ""
    @State private var supplierContact: String = ""
    @State private var sourceCountry: String = ""
    @State private var stockLevel: String = ""
    @State private var reorderThreshold: String = ""
    @State private var purchasePrice: String = ""
    @State private var unitType: String = ""
    @State private var color: String = ""
    @State private var density: String = ""
    @State private var meltingPoint: String = ""
    @State private var toxicityLevel: String = ""
    @State private var flammability: String = ""
    @State private var safetyNotes: String = ""
    @State private var storageLocation: String = ""
    @State private var receivedDate: Date = Date()
    @State private var expiryDate: Date = Date().addingTimeInterval(86400 * 365)
    @State private var qualityGrade: String = "A"
    @State private var batchCode: String = ""
    @State private var usageCount: String = "0"
    @State private var isReusable: Bool = true
    @State private var tags: String = ""
    
    @State private var showAlert: Bool = false
    @State private var validationMessage: String = ""
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Name is required.")
        }
        if code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Code is required.")
        }
        if category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Category is required.")
        }
        if subCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Sub-Category is required.")
        }
        if supplier.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Supplier is required.")
        }
        if sourceCountry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Source Country is required.")
        }
        if unitType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Unit Type is required.")
        }
        if color.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Color is required.")
        }
        if toxicityLevel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Toxicity Level is required.")
        }
        if flammability.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Flammability is required.")
        }
        if storageLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Storage Location is required.")
        }
        if qualityGrade.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Quality Grade is required.")
        }
        if batchCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("• Batch Code is required.")
        }
        
        if Int(stockLevel) == nil || Int(stockLevel)! < 0 {
            errors.append("• Stock Level must be a non-negative number.")
        }
        if Int(reorderThreshold) == nil || Int(reorderThreshold)! < 0 {
            errors.append("• Reorder Threshold must be a non-negative number.")
        }
        if Double(purchasePrice) == nil || Double(purchasePrice)! <= 0 {
            errors.append("• Purchase Price must be a positive number.")
        }
        if Double(density) == nil || Double(density)! <= 0 {
            errors.append("• Density must be a positive number.")
        }
        if Double(meltingPoint) == nil || Double(meltingPoint)! <= 0 {
            errors.append("• Melting Point must be a positive number.")
        }
        if Int(usageCount) == nil || Int(usageCount)! < 0 {
            errors.append("• Usage Count must be a non-negative number.")
        }
        
        if errors.isEmpty {
            let newItem = MaterialItem(
                id: UUID(),
                name: name,
                code: code,
                category: category,
                subCategory: subCategory,
                supplier: supplier,
                supplierContact: supplierContact,
                sourceCountry: sourceCountry,
                stockLevel: Int(stockLevel) ?? 0,
                reorderThreshold: Int(reorderThreshold) ?? 0,
                purchasePrice: Double(purchasePrice) ?? 0.0,
                unitType: unitType,
                color: color,
                density: Double(density) ?? 0.0,
                meltingPoint: Double(meltingPoint) ?? 0.0,
                toxicityLevel: toxicityLevel,
                flammability: flammability,
                safetyNotes: safetyNotes,
                storageLocation: storageLocation,
                receivedDate: receivedDate,
                expiryDate: expiryDate,
                qualityGrade: qualityGrade,
                batchCode: batchCode,
                usageCount: Int(usageCount) ?? 0,
                isReusable: isReusable,
                tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            )
            
            dataStore.addMaterial(newItem)
            
            validationMessage = "✅ Success!\n'\(name)' has been added to the inventory."
            showAlert = true
        } else {
            validationMessage = "🛑 Validation Errors:\n\n" + errors.joined(separator: "\n")
            showAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    MaterialItemAddSectionHeaderView(title: "Identity & Classification", iconName: "tag.circle.fill")
                    
                    VStack(spacing: 15) {
                        MaterialItemAddFieldView(text: $name, title: "Material Name", placeholder: "e.g., Silica Sand", iconName: "cube.box.fill")
                        
                        HStack(spacing: 15) {
                            MaterialItemAddFieldView(text: $code, title: "Code", placeholder: "MAT-001", iconName: "barcode")
                            MaterialItemAddFieldView(text: $category, title: "Category", placeholder: "e.g., Base", iconName: "folder.fill")
                        }
                        
                        HStack(spacing: 15) {
                            MaterialItemAddFieldView(text: $subCategory, title: "Sub-Category", placeholder: "e.g., Primary", iconName: "folder.badge.gear")
                            MaterialItemAddFieldView(text: $qualityGrade, title: "Quality Grade", placeholder: "e.g., A+", iconName: "star.fill")
                        }
                    }
                    
                    MaterialItemAddSectionHeaderView(title: "Inventory & Pricing", iconName: "dollarsign.circle.fill")
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            MaterialItemAddFieldView(text: $stockLevel, title: "Stock Level (Int)", placeholder: "2500", iconName: "list.number")
                                .keyboardType(.numberPad)
                            MaterialItemAddFieldView(text: $reorderThreshold, title: "Reorder Threshold (Int)", placeholder: "500", iconName: "bell.fill")
                                .keyboardType(.numberPad)
                        }
                        
                        HStack(spacing: 15) {
                            MaterialItemAddFieldView(text: $purchasePrice, title: "Purchase Price (Dbl)", placeholder: "20.50", iconName: "banknote.fill")
                                .keyboardType(.decimalPad)
                            MaterialItemAddFieldView(text: $unitType, title: "Unit Type", placeholder: "kg", iconName: "scalemass.fill")
                        }
                        
                        MaterialItemAddFieldView(text: $usageCount, title: "Usage Count (Int)", placeholder: "120", iconName: "chart.bar.fill")
                            .keyboardType(.numberPad)
                    }
                    
                    MaterialItemAddSectionHeaderView(title: "Properties & Safety", iconName: "gearshape.fill")
                    
                    VStack(spacing: 15) {
                        HStack(alignment: .top, spacing: 15) {
                            VStack(spacing: 15) {
                                MaterialItemAddFieldView(text: $color, title: "Color", placeholder: "White/Clear", iconName: "eyedropper.full.fill")
                                MaterialItemAddFieldView(text: $density, title: "Density (Dbl)", placeholder: "2.65", iconName: "ruler.fill")
                                    .keyboardType(.decimalPad)
                                MaterialItemAddFieldView(text: $toxicityLevel, title: "Toxicity Level", placeholder: "Low/High", iconName: "ladybug.fill")
                            }
                            
                            VStack(spacing: 15) {
                                MaterialItemAddFieldView(text: $meltingPoint, title: "Melting Point (Dbl)", placeholder: "1700.0", iconName: "flame.fill")
                                    .keyboardType(.decimalPad)
                                MaterialItemAddFieldView(text: $flammability, title: "Flammability", placeholder: "None/High", iconName: "exclamationmark.triangle.fill")
                                MaterialItemAddBoolFieldView(isOn: $isReusable, title: "Is Reusable", iconName: "arrow.triangle.2.circlepath")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    MaterialItemAddSectionHeaderView(title: "Logistics & Dates", iconName: "calendar.circle.fill")
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 15) {
                            MaterialItemAddFieldView(text: $supplier, title: "Supplier Name", placeholder: "Crystal Supply Co.", iconName: "person.3.fill")
                            MaterialItemAddFieldView(text: $supplierContact, title: "Supplier Contact", placeholder: "+123...", iconName: "phone.fill")
                                .keyboardType(.phonePad)
                        }
                        
                        HStack(spacing: 15) {
                            MaterialItemAddFieldView(text: $sourceCountry, title: "Source Country", placeholder: "Australia", iconName: "flag.fill")
                            MaterialItemAddFieldView(text: $storageLocation, title: "Storage Location", placeholder: "Warehouse A-1", iconName: "building.2.fill")
                        }
                        
                        MaterialItemAddFieldView(text: $batchCode, title: "Batch Code", placeholder: "SAND-2025-A", iconName: "tag.slash.fill")
                        
                        MaterialItemAddDatePickerView(date: $receivedDate, title: "Received Date", iconName: "arrow.down.to.line.alt")
                        MaterialItemAddDatePickerView(date: $expiryDate, title: "Expiry Date", iconName: "calendar.badge.exclamationmark")
                    }
                    
                    MaterialItemAddSectionHeaderView(title: "Notes & Tagging", iconName: "note.text")
                    
                    VStack(spacing: 15) {
                        MaterialItemAddFieldView(text: $safetyNotes, title: "Safety Notes", placeholder: "E.g., Handle with mask.", iconName: "clipboard.fill")
                        
                        MaterialItemAddFieldView(text: $tags, title: "Tags (Comma Separated)", placeholder: "silica, raw, stock", iconName: "paperclip")
                    }
                    
                    Button(action: validateAndSave) {
                        Text("Save New Material Item")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.68, green: 0.32, blue: 0.87))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                    
                }
                .padding(.vertical, 10)
            }
            .navigationBarTitle("Add Material Item", displayMode: .inline)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(validationMessage.contains("✅") ? "Submission Status" : "Validation Failed"),
                message: Text(validationMessage),
                dismissButton: .default(Text("OK")) {
                    if validationMessage.contains("✅") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}


@available(iOS 14.0, *)
struct MaterialItemAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.purpleiOS14)
            Text(title)
                .font(.headline)
                .foregroundColor(Color(.darkGray))
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 15)
    }
}

@available(iOS 14.0, *)
struct MaterialItemAddFieldView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(.systemGray))
                .opacity(text.isEmpty ? 0 : 1)
                .animation(.easeIn(duration: 0.1))
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.purpleiOS14)
                
                TextField(placeholder, text: $text)
                    .foregroundColor(Color(.label))
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct MaterialItemAddDatePickerView: View {
    @Binding var date: Date
    let title: String
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            MaterialItemAddSectionHeaderView(title: title, iconName: iconName)
                .padding(.top, 0)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }
}

@available(iOS 14.0, *)
struct MaterialItemAddBoolFieldView: View {
    @Binding var isOn: Bool
    let title: String
    let iconName: String
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.purpleiOS14)
                Text(title)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
