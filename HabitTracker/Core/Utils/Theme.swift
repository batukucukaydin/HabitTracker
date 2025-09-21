// -------------------------------------------------------------
// Core/Utils/Theme.swift
// -------------------------------------------------------------
import SwiftUI

enum Theme {
    static let brandOrange = Color(red: 1.0, green: 0.45, blue: 0.10)
    static let brandDark   = Color(red: 0.06, green: 0.06, blue: 0.07)
    static let brandDark2  = Color(red: 0.12, green: 0.12, blue: 0.14)

    static let appBackground = LinearGradient(
        colors: [brandDark, brandDark2],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let tabBarBackground = Color.black.opacity(0.65)

    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.06), Color.white.opacity(0.02)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let cardStroke = Color.white.opacity(0.08)
}

extension Color { var uiColor: UIColor { UIColor(self) } }
