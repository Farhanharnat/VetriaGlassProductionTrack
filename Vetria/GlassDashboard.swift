
import SwiftUI

@available(iOS 14.0, *)
struct GlassDashboard: View {
    @StateObject private var store = GlassDataStore()

    var body: some View {
        NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        header
                            .padding([.leading, .trailing], 20)

                        overviewGrid()
                            .padding(.horizontal, 20)

                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
                .navigationBarHidden(true)
                .background(BackgroundView())
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Stylish Glass")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                Text("Factory dashboard")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
            }
            Spacer()

        }
        .padding(.vertical, 10)
    }

    private func overviewGrid() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        return LazyVGrid(columns: columns, spacing: 50) {
            
            NavigationLink(destination: GlassProcessListView().environmentObject(store)) {
                DashboardTile(title: "Processes", value: "\(store.processes.count)", subtitle: "Active", icon: "flame.fill", color: Palette.heat)
            }

            NavigationLink(destination: MaterialItemListView().environmentObject(store)) {
                DashboardTile(title: "Materials", value: "\(store.materials.count)", subtitle: "In Stock", icon: "cube.box.fill", color: Palette.material)
            }

            NavigationLink(destination: ProductionTaskListView().environmentObject(store)) {
                DashboardTile(title: "Tasks", value: "\(store.tasks.count)", subtitle: "Open", icon: "hammer.fill", color: Palette.task)
            }

            NavigationLink(destination: ClientOrderListView().environmentObject(store)) {
                DashboardTile(title: "Orders", value: "\(store.orders.count)", subtitle: "Pending", icon: "cart.fill", color: Palette.order)
            }

            NavigationLink(destination: DeliveryRecordListView().environmentObject(store)) {
                if #available(iOS 16.0, *) {
                    DashboardTile(title: "Deliveries", value: "\(store.deliveries.count)", subtitle: "Today", icon: "truck.fill", color: Palette.delivery)
                        .gridCellColumns(2)
                } else {
                    // Fallback for iOS 14–15 (no spanning)
                    DashboardTile(title: "Deliveries", value: "\(store.deliveries.count)", subtitle: "Today", icon: "truck.fill", color: Palette.delivery)
                }
            }
        }
    }


    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick actions")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .padding(.leading, 6)

            HStack(spacing: 12) {
                ActionButton(label: "New Process", systemIcon: "plus", color: Palette.heat) {
                    let new = GlassProcess(id: UUID(), title: "New Process", description: "", processType: "", temperature: "", durationMinutes: 0, pressureLevel: "", toolUsed: "", supervisor: "", batchNumber: "", dateCreated: Date(), lastModified: Date(), stage: "", safetyLevel: "", notes: "", qualityCheckStatus: "", energyUsedKWh: 0, wastagePercent: 0, colorType: "", thicknessMM: 0, clarityRating: "", humidityLevel: "", resultCode: "", location: "", approvalStatus: "", maintenanceNeeded: false, tags: [])
                    store.addProcess(new)
                }

                ActionButton(label: "Add Material", systemIcon: "tray.and.arrow.down.fill", color: Palette.material) {
                    let new = MaterialItem(id: UUID(), name: "New Material", code: "", category: "", subCategory: "", supplier: "", supplierContact: "", sourceCountry: "", stockLevel: 0, reorderThreshold: 0, purchasePrice: 0, unitType: "kg", color: "", density: 0, meltingPoint: 0, toxicityLevel: "", flammability: "", safetyNotes: "", storageLocation: "", receivedDate: Date(), expiryDate: Date(), qualityGrade: "", batchCode: "", usageCount: 0, isReusable: false, tags: [])
                    store.addMaterial(new)
                }

                ActionButton(label: "New Order", systemIcon: "doc.badge.plus", color: Palette.order) {
                    let new = ClientOrder(id: UUID(), orderNumber: "ORD-\(Int.random(in: 1000...9999))", clientName: "New Client", clientPhone: "", clientEmail: "", clientAddress: "", orderDetails: "", quantity: 0, unitPrice: 0, totalPrice: 0, orderDate: Date(), expectedDeliveryDate: Date(), status: "", paymentMethod: "", paymentStatus: "", discountPercent: 0, taxPercent: 0, shippingMethod: "", shippingCost: 0, specialInstructions: "", handledBy: "", region: "", priorityLevel: "", confirmationCode: "", refundEligible: false, tags: [])
                    store.addOrder(new)
                }
            }
        }
    }
}

// MARK: - Small Components

struct DashboardTile: View {
    var title: String
    var value: String
    var subtitle: String
    var icon: String
    var color: Color

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [color.opacity(0.4), color.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: color.opacity(0.08), radius: 8, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(8)
                        .background(color.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Spacer()
                }

                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)
                Text(value)
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(Color.white)
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white)
                    .opacity(0.7)
            }
            .padding(14)
        }
        .frame(height: 120)
    }
}

struct ActionButton: View {
    var label: String
    var systemIcon: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemIcon)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Text(label)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.001)))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AvatarView: View {
    var initials: String
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 44, height: 44)
                .overlay(Circle().stroke(Color.white.opacity(0.06), lineWidth: 1))
            Text(initials)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
        }
    }
}

// MARK: - Background / Palette

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Palette.bg1, Palette.bg2]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            // Subtle decorative shapes for unique look (non-intrusive and App Store safe)
            Circle()
                .fill(Palette.ambient.opacity(0.06))
                .frame(width: 300, height: 300)
                .offset(x: -120, y: -200)

            RoundedRectangle(cornerRadius: 120)
                .fill(Palette.ambient.opacity(0.03))
                .frame(width: 500, height: 160)
                .rotationEffect(.degrees(18))
                .offset(x: 120, y: 220)
        }
    }
}

enum Palette {
    static let bg1 = Color(red: 12/255, green: 16/255, blue: 25/255)
    static let bg2 = Color(red: 24/255, green: 30/255, blue: 41/255)
    static let heat = Color(red: 220/255, green: 95/255, blue: 70/255)
    static let material = Color(red: 80/255, green: 145/255, blue: 200/255)
    static let task = Color(red: 140/255, green: 200/255, blue: 120/255)
    static let order = Color(red: 175/255, green: 115/255, blue: 210/255)
    static let delivery = Color(red: 255/255, green: 195/255, blue: 75/255)
    static let ambient = Color(red: 255/255, green: 255/255, blue: 255/255)
}

