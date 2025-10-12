
import Foundation
import Combine

final class GlassDataStore: ObservableObject {
    
    @Published var processes: [GlassProcess] = []
    @Published var materials: [MaterialItem] = []
    @Published var tasks: [ProductionTask] = []
    @Published var orders: [ClientOrder] = []
    @Published var deliveries: [DeliveryRecord] = []
    
    private let defaults = UserDefaults.standard
    
    init() {
        loadData()
        if processes.isEmpty && materials.isEmpty && tasks.isEmpty && orders.isEmpty && deliveries.isEmpty {
            loadDummyData()
        }
    }
    
    
    func addProcess(_ process: GlassProcess) {
        processes.append(process)
        saveData()
    }
    
    func addMaterial(_ material: MaterialItem) {
        materials.append(material)
        saveData()
    }
    
    func addTask(_ task: ProductionTask) {
        tasks.append(task)
        saveData()
    }
    
    func addOrder(_ order: ClientOrder) {
        orders.append(order)
        saveData()
    }
    
    func addDelivery(_ delivery: DeliveryRecord) {
        deliveries.append(delivery)
        saveData()
    }
    
    // MARK: - Delete Data
    
    func deleteProcess(_ id: UUID) {
        processes.removeAll { $0.id == id }
        saveData()
    }
    
    func deleteMaterial(_ id: UUID) {
        materials.removeAll { $0.id == id }
        saveData()
    }
    
    func deleteTask(_ id: UUID) {
        tasks.removeAll { $0.id == id }
        saveData()
    }
    
    func deleteOrder(_ id: UUID) {
        orders.removeAll { $0.id == id }
        saveData()
    }
    
    func deleteDelivery(_ id: UUID) {
        deliveries.removeAll { $0.id == id }
        saveData()
    }
    
    
    private func saveData() {
        save(processes, key: "processes")
        save(materials, key: "materials")
        save(tasks, key: "tasks")
        save(orders, key: "orders")
        save(deliveries, key: "deliveries")
    }
    
    private func save<T: Codable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }
    
    private func loadData() {
        processes = load(key: "processes") ?? []
        materials = load(key: "materials") ?? []
        tasks = load(key: "tasks") ?? []
        orders = load(key: "orders") ?? []
        deliveries = load(key: "deliveries") ?? []
    }
    
    private func load<T: Codable>(key: String) -> T? {
        guard let data = defaults.data(forKey: key),
              let value = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return value
    }
    
    
    func loadDummyData() {
        let now = Date()
        
        processes = [
            GlassProcess(
                id: UUID(),
                title: "Tempered Glass Heating",
                description: "Heat glass at 620°C for strength.",
                processType: "Heating",
                temperature: "620°C",
                durationMinutes: 45,
                pressureLevel: "Normal",
                toolUsed: "Furnace A2",
                supervisor: "John Doe",
                batchNumber: "BATCH-001",
                dateCreated: now,
                lastModified: now,
                stage: "Initial",
                safetyLevel: "High",
                notes: "Ensure slow cooling.",
                qualityCheckStatus: "Pending",
                energyUsedKWh: 12.5,
                wastagePercent: 1.5,
                colorType: "Clear",
                thicknessMM: 6.0,
                clarityRating: "A+",
                humidityLevel: "30%",
                resultCode: "OK-001",
                location: "Plant 1",
                approvalStatus: "Approved",
                maintenanceNeeded: false,
                tags: ["heating", "tempered"]
            )
        ]
        
        // Material Items
        materials = [
            MaterialItem(
                id: UUID(),
                name: "Silica Sand",
                code: "MAT-001",
                category: "Base",
                subCategory: "Primary",
                supplier: "Crystal Supply Co.",
                supplierContact: "+1234567890",
                sourceCountry: "Australia",
                stockLevel: 2500,
                reorderThreshold: 500,
                purchasePrice: 20.5,
                unitType: "kg",
                color: "White",
                density: 2.65,
                meltingPoint: 1700.0,
                toxicityLevel: "Low",
                flammability: "None",
                safetyNotes: "Handle with mask.",
                storageLocation: "Warehouse A",
                receivedDate: now,
                expiryDate: now.addingTimeInterval(86400 * 365),
                qualityGrade: "A",
                batchCode: "SAND-2025",
                usageCount: 120,
                isReusable: true,
                tags: ["silica", "sand", "raw"]
            )
        ]
        
        // Production Tasks
        tasks = [
            ProductionTask(
                id: UUID(),
                title: "Cutting Glass Sheets",
                description: "Cut large sheets into standard sizes.",
                assignedTo: "Michael",
                department: "Cutting",
                priorityLevel: "High",
                dueDate: now.addingTimeInterval(86400),
                createdDate: now,
                startTime: now,
                endTime: now.addingTimeInterval(3600),
                status: "In Progress",
                progressPercent: 60,
                timeSpentMinutes: 45,
                requiredTools: ["Cutter", "Safety Goggles"],
                safetyCompliance: true,
                remarks: "Good accuracy.",
                supervisorName: "Sara",
                costEstimate: 45.0,
                approvalRequired: true,
                approvalStatus: "Approved",
                delayReason: "None",
                stage: "Mid",
                outcome: "Smooth edges",
                lastUpdated: now,
                referenceCode: "TASK-001",
                tags: ["cutting", "process"]
            )
        ]
        
        // Client Orders
        orders = [
            ClientOrder(
                id: UUID(),
                orderNumber: "ORD-1001",
                clientName: "BrightGlass Ltd",
                clientPhone: "+987654321",
                clientEmail: "info@brightglass.com",
                clientAddress: "123 Market Road",
                orderDetails: "50 tempered glass sheets 6mm",
                quantity: 50,
                unitPrice: 25.0,
                totalPrice: 1250.0,
                orderDate: now,
                expectedDeliveryDate: now.addingTimeInterval(86400 * 3),
                status: "Processing",
                paymentMethod: "Cash",
                paymentStatus: "Pending",
                discountPercent: 5.0,
                taxPercent: 10.0,
                shippingMethod: "Truck",
                shippingCost: 100.0,
                specialInstructions: "Handle carefully",
                handledBy: "Liam",
                region: "Central",
                priorityLevel: "Normal",
                confirmationCode: "CONF-001",
                refundEligible: false,
                tags: ["client", "order"]
            )
        ]
        
        // Delivery Records
        deliveries = [
            DeliveryRecord(
                id: UUID(),
                deliveryNumber: "DEL-1001",
                driverName: "Alex",
                vehicleID: "VH-234",
                licensePlate: "XYZ-123",
                routeCode: "R001",
                startLocation: "Plant 1",
                destination: "BrightGlass Ltd",
                distanceKM: 45.0,
                estimatedTimeMinutes: 60,
                actualTimeMinutes: 58,
                fuelUsedLiters: 5.5,
                startDate: now,
                deliveryDate: now.addingTimeInterval(3600),
                isDelivered: true,
                status: "Completed",
                packageCount: 50,
                fragileItems: 50,
                temperatureRequirement: "Ambient",
                deliveryNotes: "Delivered without damage.",
                receiverName: "Daniel",
                receiverSignature: "Daniel_Sign",
                feedbackRating: 5,
                issueReported: false,
                issueDescription: "",
                completionCode: "COMP-001",
                tags: ["delivery", "complete"]
            )
        ]
        
        saveData()
    }
}

struct GlassProcess: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var description: String
    var processType: String
    var temperature: String
    var durationMinutes: Int
    var pressureLevel: String
    var toolUsed: String
    var supervisor: String
    var batchNumber: String
    var dateCreated: Date
    var lastModified: Date
    var stage: String
    var safetyLevel: String
    var notes: String
    var qualityCheckStatus: String
    var energyUsedKWh: Double
    var wastagePercent: Double
    var colorType: String
    var thicknessMM: Double
    var clarityRating: String
    var humidityLevel: String
    var resultCode: String
    var location: String
    var approvalStatus: String
    var maintenanceNeeded: Bool
    var tags: [String]
}

struct MaterialItem: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var code: String
    var category: String
    var subCategory: String
    var supplier: String
    var supplierContact: String
    var sourceCountry: String
    var stockLevel: Int
    var reorderThreshold: Int
    var purchasePrice: Double
    var unitType: String
    var color: String
    var density: Double
    var meltingPoint: Double
    var toxicityLevel: String
    var flammability: String
    var safetyNotes: String
    var storageLocation: String
    var receivedDate: Date
    var expiryDate: Date
    var qualityGrade: String
    var batchCode: String
    var usageCount: Int
    var isReusable: Bool
    var tags: [String]
}


struct ProductionTask: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var description: String
    var assignedTo: String
    var department: String
    var priorityLevel: String
    var dueDate: Date
    var createdDate: Date
    var startTime: Date
    var endTime: Date
    var status: String
    var progressPercent: Int
    var timeSpentMinutes: Int
    var requiredTools: [String]
    var safetyCompliance: Bool
    var remarks: String
    var supervisorName: String
    var costEstimate: Double
    var approvalRequired: Bool
    var approvalStatus: String
    var delayReason: String
    var stage: String
    var outcome: String
    var lastUpdated: Date
    var referenceCode: String
    var tags: [String]
}


struct ClientOrder: Identifiable, Codable, Hashable {
    var id: UUID
    var orderNumber: String
    var clientName: String
    var clientPhone: String
    var clientEmail: String
    var clientAddress: String
    var orderDetails: String
    var quantity: Int
    var unitPrice: Double
    var totalPrice: Double
    var orderDate: Date
    var expectedDeliveryDate: Date
    var status: String
    var paymentMethod: String
    var paymentStatus: String
    var discountPercent: Double
    var taxPercent: Double
    var shippingMethod: String
    var shippingCost: Double
    var specialInstructions: String
    var handledBy: String
    var region: String
    var priorityLevel: String
    var confirmationCode: String
    var refundEligible: Bool
    var tags: [String]
}


struct DeliveryRecord: Identifiable, Codable, Hashable {
    var id: UUID
    var deliveryNumber: String
    var driverName: String
    var vehicleID: String
    var licensePlate: String
    var routeCode: String
    var startLocation: String
    var destination: String
    var distanceKM: Double
    var estimatedTimeMinutes: Int
    var actualTimeMinutes: Int
    var fuelUsedLiters: Double
    var startDate: Date
    var deliveryDate: Date
    var isDelivered: Bool
    var status: String
    var packageCount: Int
    var fragileItems: Int
    var temperatureRequirement: String
    var deliveryNotes: String
    var receiverName: String
    var receiverSignature: String
    var feedbackRating: Int
    var issueReported: Bool
    var issueDescription: String
    var completionCode: String
    var tags: [String]
}
