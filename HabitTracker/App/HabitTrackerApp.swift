// -------------------------------------------------------------
// App/HabitTrackerApp.swift
// -------------------------------------------------------------
import SwiftUI

@main
struct HabitTrackerApp: App {
@StateObject private var di = DIContainer()
@State private var showSplash = true

var body: some Scene {
WindowGroup {
ZStack {
RootTabView()
.environmentObject(di)
.tint(Theme.brandOrange)
.background(Theme.appBackground.ignoresSafeArea())
if showSplash { SplashView().transition(.opacity.combined(with: .scale)) }
}
.onAppear {
DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
withAnimation(.easeInOut(duration: 0.6)) { showSplash = false }
}
}
}
}
}

struct RootTabView: View {
var body: some View {
TabView {
DashboardRouter.makeView()
.tabItem { Label("Dashboard", systemImage: "chart.pie.fill") }
HabitListRouter.makeView()
.tabItem { Label("Habits", systemImage: "checkmark.circle") }
InsightsRouter.makeView()
.tabItem { Label("Insights", systemImage: "chart.bar.xaxis") }
}
.background(Theme.appBackground)
.toolbarBackground(.visible, for: .tabBar)
.toolbarBackground(Theme.tabBarBackground, for: .tabBar)
}
}
