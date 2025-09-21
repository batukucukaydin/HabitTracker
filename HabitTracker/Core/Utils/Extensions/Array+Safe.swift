//
//  Array+Safe.swift
//  HabitTracker
//
//  Created by Batuhan Kucukaydın on 21.09.2025.
//


extension Array { subscript(safe i: Int) -> Element? { indices.contains(i) ? self[i] : nil } }
