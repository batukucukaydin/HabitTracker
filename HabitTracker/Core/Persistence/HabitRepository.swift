// -------------------------------------------------------------
// Core/Persistence/HabitRepository.swift
// -------------------------------------------------------------
import Foundation
import CoreData

public struct HabitDTO: Identifiable, Hashable {
    public let id: UUID
    public var title: String
    public var icon: String
    public var targetPerDay: Int
    public var completedToday: Int
    public var history: [Date: Int]
    public var createdAt: Date
    public var updatedAt: Date
    public var isArchived: Bool
}

protocol HabitRepositoryProtocol {
    func fetchAll() throws -> [HabitDTO]
    func add(title: String, icon: String, targetPerDay: Int) throws
    func toggleComplete(_ habitID: UUID) throws
    func setCompletion(_ habitID: UUID, value: Int) throws
    func delete(_ habitID: UUID) throws
    func resetTodayCountsIfNeeded() throws
}

final class HabitRepository: HabitRepositoryProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) { self.context = context }

    func fetchAll() throws -> [HabitDTO] {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.predicate = NSPredicate(format: "isArchived == NO")
        let items = try context.fetch(req)
        return items.compactMap { $0.toDTO() }
    }

    func add(title: String, icon: String, targetPerDay: Int) throws {
        let h = Habit(context: context)
        h.id = UUID()
        h.title = title
        h.icon = icon
        h.targetPerDay = Int16(targetPerDay)
        h.completedToday = 0
        h.history = [:] as NSDictionary
        h.createdAt = Date()
        h.updatedAt = Date()
        h.isArchived = false
        try context.save()
    }

    func toggleComplete(_ habitID: UUID) throws {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", habitID as CVarArg)
        guard let h = try context.fetch(req).first else { return }
        let newVal = Int(h.completedToday) + 1
        h.completedToday = Int16(min(Int(h.targetPerDay), newVal))
        h.updatedAt = Date()
        try context.save()
    }

    func setCompletion(_ habitID: UUID, value: Int) throws {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", habitID as CVarArg)
        guard let h = try context.fetch(req).first else { return }
        h.completedToday = Int16(max(0, min(Int(h.targetPerDay), value)))
        h.updatedAt = Date()
        try context.save()
    }

    func delete(_ habitID: UUID) throws {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", habitID as CVarArg)
        if let h = try context.fetch(req).first { context.delete(h); try context.save() }
    }

    func resetTodayCountsIfNeeded() throws {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        let items = try context.fetch(req)
        let cal = Calendar.current
        for h in items {
            // If date changed, archive yesterday’s count
            if let updated = h.updatedAt, !cal.isDateInToday(updated) {
                var hist = (h.history as? [Date: Int]) ?? [:]
                let key = cal.startOfDay(for: updated)
                hist[key] = Int(h.completedToday)
                h.history = hist as NSDictionary
                h.completedToday = 0
                h.updatedAt = Date()
            }
        }
        if context.hasChanges { try context.save() }
    }
}

extension Habit {
    func toDTO() -> HabitDTO? {
        guard let id = id, let title = title, let icon = icon, let createdAt = createdAt, let updatedAt = updatedAt else { return nil }
        return HabitDTO(
            id: id, title: title, icon: icon,
            targetPerDay: Int(targetPerDay),
            completedToday: Int(completedToday),
            history: (history as? [Date: Int]) ?? [:],
            createdAt: createdAt, updatedAt: updatedAt, isArchived: isArchived
        )
    }
}
