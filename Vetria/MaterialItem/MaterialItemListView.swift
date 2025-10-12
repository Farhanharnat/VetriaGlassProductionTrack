
import SwiftUI

@available(iOS 14.0, *)
struct MaterialItemListView: View {
    @EnvironmentObject var dataStore: GlassDataStore
    @State private var searchText: String = ""
    
    var filteredMaterials: [MaterialItem] {
        if searchText.isEmpty {
            return dataStore.materials
        } else {
            return dataStore.materials.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.code.localizedCaseInsensitiveContains(searchText) ||
                item.supplier.localizedCaseInsensitiveContains(searchText) ||
                item.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                MaterialItemSearchBarView(searchText: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                
                if filteredMaterials.isEmpty {
                    MaterialItemNoDataView(
                        iconName: searchText.isEmpty ? "shippingbox.fill" : "magnifyingglass.slash",
                        message: searchText.isEmpty ? "No material items found in inventory." : "No results for '\(searchText)'."
                    )
                } else {
                    List {
                        ForEach(filteredMaterials) { item in
                            NavigationLink(destination: MaterialItemDetailView(item: item)) {
                                MaterialItemListRowView(item: item)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, -10)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteMaterial)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Material Inventory", displayMode: .large)
            .navigationBarItems(trailing:
                                    NavigationLink(destination: MaterialItemAddView().environmentObject(dataStore)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.purpleiOS14)
                }
            )
        
    }
    
    func deleteMaterial(at offsets: IndexSet) {
        let idsToDelete = offsets.map { self.filteredMaterials[$0].id }
        
        for id in idsToDelete {
            dataStore.deleteMaterial(id)
        }
    }
}


@available(iOS 14.0, *)
struct MaterialItemSearchBarView: View {
    @Binding var searchText: String
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            TextField("Search Materials...", text: $searchText)
                .padding(7)
                .padding(.leading, 30)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(.systemGray))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing && !searchText.isEmpty {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color(.systemGray))
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .animation(.easeInOut(duration: 0.2))
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

@available(iOS 14.0, *)
struct MaterialItemNoDataView: View {
    let iconName: String
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.tealiOS14)
                .padding(.bottom, 10)
            
            Text(message)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color(.systemGray))
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct MaterialItemListRowView: View {
    let item: MaterialItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: item.isReusable ? "arrow.triangle.2.circlepath.circle.fill" : "cube.fill")
                    .foregroundColor(item.isReusable ? .green : .blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(Color(.label))
                    Text(item.category + " / " + item.subCategory)
                        .font(.caption)
                        .foregroundColor(Color(.systemGray))
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Qty: \(item.stockLevel) \(item.unitType)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(item.stockLevel < item.reorderThreshold ? .red : .primary)
                    
                    Text("Code: \(item.code)")
                        .font(.caption2)
                        .foregroundColor(Color(.systemGray2))
                }
            }
            .padding(.bottom, 5)
            
            VStack(spacing: 6) {
                HStack {
                    MaterialItemInfoPill(icon: "dollarsign.circle.fill", text: String(format: "Price: $%.2f", item.purchasePrice), color: .purpleiOS14)
                    Spacer()
                    MaterialItemInfoPill(icon: "person.2.fill", text: "Supplier: \(item.supplier)", color: .orangeiOS14)
                }
                
                HStack{
                    MaterialItemInfoPill(icon: "flag.fill", text: "Country: \(item.sourceCountry)", color: .red)
                    Spacer()
                    MaterialItemInfoPill(icon: "flame.fill", text: String(format: "Melt: %.0f°C", item.meltingPoint), color: .pinkiOS14)

                }
                HStack {
                    MaterialItemInfoPill(icon: "ruler.fill", text: String(format: "Density: %.2f", item.density), color: .tealiOS14)
                    Spacer()
                    MaterialItemInfoPill(icon: "thermometer.sun.fill", text: "Flam.: \(item.flammability)", color: .yellow)
                }
                
                HStack {
                    MaterialItemInfoPill(icon: "building.2.fill", text: "Loc: \(item.storageLocation)", color: .indigoiOS14)
                    Spacer()
                    MaterialItemInfoPill(icon: "star.fill", text: "Grade: \(item.qualityGrade)", color: .green)
                }
                
                HStack {
                    MaterialItemInfoPill(icon: "tag.fill", text: "Batch: \(item.batchCode)", color: .gray)
                    Spacer()
                    MaterialItemInfoPill(icon: "arrow.down.to.line.alt", text: "Rec'd: \(item.receivedDate)", color: .blue)

                }
                
                HStack {
                    MaterialItemInfoPill(icon: "calendar.badge.exclamationmark", text: "Expiry: \(item.expiryDate)", color: .red)
                    Spacer()
                    MaterialItemInfoPill(icon: "chart.bar.fill", text: "Used: \(item.usageCount) times", color: .cyaniOS14)
                }
                
                HStack {
                    MaterialItemInfoPill(icon: "ladybug.fill", text: "Tox: \(item.toxicityLevel)", color: .red)
                    Spacer()
                    MaterialItemInfoPill(icon: "bell.fill", text: "Reorder: \(item.reorderThreshold)", color: .orange)
                }
                
                Text("Notes: \(item.safetyNotes)")
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(Color(.systemGray))
                    .padding(.top, 4)
            }
        }
        .padding(15)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct MaterialItemInfoPill: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.white)
            Text(text)
                .font(.system(size: 16))
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(color)
        .cornerRadius(8)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
}

@available(iOS 14.0, *)
struct MaterialItemDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String
    let valueColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.purpleiOS14)
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(.systemGray))
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 14.0, *)
struct MaterialItemDetailGroupBlock<Content: View>: View {
    let title: String
    let iconName: String
    let content: Content
    
    init(title: String, iconName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.tealiOS14)
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
            }
            .padding(.bottom, 5)
            
            VStack(spacing: 8) {
                content
            }
            .padding(12)
            .cornerRadius(10)
        }.frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
}
