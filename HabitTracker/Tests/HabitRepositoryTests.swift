//
//  HabitRepositoryTests.swift
//  HabitTracker
//
//  Created by Batuhan Kucukaydın on 21.09.2025.
//


import XCTest
import CoreData
@testable import HabitTracker


final class HabitRepositoryTests: XCTestCase {
    var repo: HabitRepositoryProtocol!; var ctx: NSManagedObjectContext!

    override func setUp() {
        let pc = PersistenceController(inMemory: true)
        ctx = pc.container.viewContext
        repo = HabitRepository(context: ctx)
    }

    func testAddFetchDelete() throws {
        try repo.add(title: "Su iç", icon: "drop", targetPerDay: 8)
        var items = try repo.fetchAll()
        XCTAssertEqual(items.count, 1)
        let id = items[0].id
        try repo.delete(id)
        items = try repo.fetchAll()
        XCTAssertEqual(items.count, 0)
    }

    func testToggleCompletion() throws {
        try repo.add(title: "Kitap oku", icon: "book", targetPerDay: 1)
        let id = try repo.fetchAll()[0].id
        try repo.toggleComplete(id)
        let updated = try repo.fetchAll()[0]
        XCTAssertEqual(updated.completedToday, 1)
    }
}
