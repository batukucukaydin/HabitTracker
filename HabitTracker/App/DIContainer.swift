//
//  DIContainer.swift
//  HabitTracker
//
//  Created by Batuhan Kucukaydın on 21.09.2025.
//

import Foundation
import CoreData

final class DIContainer: ObservableObject {
    let persistence = PersistenceController.shared
    lazy var habitRepo: HabitRepositoryProtocol = HabitRepository(context: persistence.container.viewContext)
}
