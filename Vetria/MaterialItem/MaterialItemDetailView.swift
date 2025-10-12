
import SwiftUI
import Combine


extension Color {
    static let purpleiOS14 = Color(red: 0.68, green: 0.32, blue: 0.87)
    static let tealiOS14 = Color(red: 0.20, green: 0.78, blue: 0.78)
    static let orangeiOS14 = Color(red: 1.00, green: 0.58, blue: 0.00)
    static let pinkiOS14 = Color(red: 1.00, green: 0.18, blue: 0.57)
    static let indigoiOS14 = Color(red: 0.35, green: 0.34, blue: 0.84)
    static let cyaniOS14 = Color(red: 0.26, green: 0.83, blue: 0.96)
}


@available(iOS 14.0, *)
struct MaterialItemDetailView: View {
    let item: MaterialItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: item.isReusable ? "arrow.triangle.2.circlepath.circle.fill" : "cube.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(item.isReusable ? .green : .blue)
                    
                    Text(item.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.label))
                    
                    Text("Code: \(item.code) | Batch: \(item.batchCode)")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
                .background(Color(.systemBackground))
                .cornerRadius(15)
                
                MaterialItemDetailGroupBlock(title: "Inventory Details (5 Fields)", iconName: "list.bullet.rectangle.fill") {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Stock Level", value: "\(item.stockLevel) \(item.unitType)", iconName: "number.square.fill", valueColor: item.stockLevel < item.reorderThreshold ? .red : .primary)
                            MaterialItemDetailFieldRow(label: "Reorder Threshold", value: "\(item.reorderThreshold) \(item.unitType)", iconName: "bell.fill", valueColor: .orangeiOS14)
                            MaterialItemDetailFieldRow(label: "Usage Count", value: "\(item.usageCount)", iconName: "chart.bar.fill", valueColor: .purpleiOS14)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Purchase Price", value: String(format: "$%.2f", item.purchasePrice), iconName: "dollarsign.circle.fill", valueColor: .green)
                            MaterialItemDetailFieldRow(label: "Unit Type", value: item.unitType, iconName: "scalemass.fill", valueColor: .primary)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                        .cornerRadius(15)
                
                MaterialItemDetailGroupBlock(title: "Classification & Quality (5 Fields)", iconName: "tag.fill") {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Category", value: item.category, iconName: "folder.fill", valueColor: .primary)
                            MaterialItemDetailFieldRow(label: "Sub-Category", value: item.subCategory, iconName: "folder.badge.gear", valueColor: .primary)
                            MaterialItemDetailFieldRow(label: "Quality Grade", value: item.qualityGrade, iconName: "star.fill", valueColor: item.qualityGrade.contains("A") ? .tealiOS14 : .orangeiOS14)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Batch Code", value: item.batchCode, iconName: "tag.slash.fill", valueColor: .primary)
                            MaterialItemDetailFieldRow(label: "Reusable Status", value: item.isReusable ? "Yes" : "No", iconName: "arrow.triangle.2.circlepath", valueColor: item.isReusable ? .green : .red)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                        .cornerRadius(15)
                
                MaterialItemDetailGroupBlock(title: "Physical Properties (4 Fields)", iconName: "ruler.fill") {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Color", value: item.color, iconName: "eyedropper.full.fill", valueColor: .primary)
                            MaterialItemDetailFieldRow(label: "Density", value: String(format: "%.2f", item.density), iconName: "ruler.fill", valueColor: .primary)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Melting Point", value: String(format: "%.0f °C", item.meltingPoint), iconName: "flame.fill", valueColor: .primary)
                            MaterialItemDetailFieldRow(label: "Source Country", value: item.sourceCountry, iconName: "flag.fill", valueColor: .primary)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                        .cornerRadius(15)
                
                MaterialItemDetailGroupBlock(title: "Safety & Notes (4 Fields)", iconName: "cross.case.fill") {
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                MaterialItemDetailFieldRow(label: "Toxicity Level", value: item.toxicityLevel, iconName: "ladybug.fill", valueColor: item.toxicityLevel == "High" ? .red : .green)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                MaterialItemDetailFieldRow(label: "Flammability", value: item.flammability, iconName: "exclamationmark.triangle.fill", valueColor: item.flammability == "High" ? .red : .green)
                            }
                        }
                        
                        Divider().padding(.vertical, 5)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "hand.raised.fill").foregroundColor(.red)
                                Text("Safety Notes")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            Text(item.safetyNotes)
                                .font(.body)
                                .padding(.top, 2)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                        .cornerRadius(15)
                
                MaterialItemDetailGroupBlock(title: "Logistics & Supplier (4 Fields)", iconName: "map.fill") {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Supplier", value: item.supplier, iconName: "person.3.fill", valueColor: .primary)
                            MaterialItemDetailFieldRow(label: "Supplier Contact", value: item.supplierContact, iconName: "phone.fill", valueColor: .blue)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            MaterialItemDetailFieldRow(label: "Storage Location", value: item.storageLocation, iconName: "building.2.fill", valueColor: .primary)
                            MaterialItemDetailFieldRow(
                                label: "Received Date",
                                value: formattedDate(item.receivedDate),
                                iconName: "arrow.down.to.line.alt",
                                valueColor: .primary
                            )
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                        .cornerRadius(15)
                
                MaterialItemDetailGroupBlock(title: "Dates & Tags (3 Fields)", iconName: "calendar") {
                    VStack(alignment: .leading, spacing: 8) {
                        MaterialItemDetailFieldRow(
                            label: "Expiry Date",
                            value: formattedDate(item.expiryDate),
                            iconName: "calendar.badge.exclamationmark",
                            valueColor: item.expiryDate < Date().addingTimeInterval(86400 * 30) ? .red : .primary
                        )

                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "paperclip").foregroundColor(.gray)
                                Text("Tags (\(item.tags.count))")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            Text(item.tags.joined(separator: ", "))
                                .font(.caption)
                                .padding(.top, 2)
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                        .cornerRadius(15)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarTitle("Material Detail", displayMode: .inline)
        .background(Color(.systemGroupedBackground))
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

extension Date: CustomStringConvertible {
    public var description: String {
        DateFormatter.shortDate.string(from: self)
    }
}
