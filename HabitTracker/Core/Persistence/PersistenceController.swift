// -------------------------------------------------------------
// Core/Persistence/PersistenceController.swift (Core Data + App Group)
// -------------------------------------------------------------
import CoreData

struct PersistenceController {
static let shared = PersistenceController()
let container: NSPersistentContainer


init(inMemory: Bool = false, useAppGroup: Bool = false, appGroupID: String = "") {
container = NSPersistentContainer(name: "Habit")

if inMemory {
container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
} else if useAppGroup, !appGroupID.isEmpty,
let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
// Use App Group store (ONLY if capability is available)
let storeURL = groupURL.appendingPathComponent("HabitTracker.sqlite")
if let desc = container.persistentStoreDescriptions.first { desc.url = storeURL }
}

container.loadPersistentStores { _, error in
if let error = error { fatalError("Unresolved error: \(error)") }
}
container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
container.viewContext.automaticallyMergesChangesFromParent = true
}
}
