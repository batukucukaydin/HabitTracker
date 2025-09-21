//
//  HabitUseCaseTests.swift
//  HabitTracker
//
//  Created by Batuhan Kucukaydın on 21.09.2025.
//


// -------------------------------------------------------------
// Tests/HabitUseCaseTests.swift – interactor logic sample
// -------------------------------------------------------------
import XCTest
import CoreData
@testable import HabitTracker

final class HabitUseCaseTests: XCTestCase {
    func testProgressCalculation() async throws {
        let pc = PersistenceController(inMemory: true)
        let repo = HabitRepository(context: pc.container.viewContext)
        try repo.add(title: "Egzersiz", icon: "dumbbell", targetPerDay: 1)
        try repo.add(title: "Su iç", icon: "drop", targetPerDay: 8)
        for _ in 0..<4 { try repo.toggleComplete(try repo.fetchAll()[1].id) }

        let presenter = DashboardPresenter()
        let interactor = DashboardInteractor(repo: repo, presenter: presenter)
        await interactor.load()
        XCTAssert(presenter.viewModel.progress > 0 && presenter.viewModel.progress < 1)
    }
}
