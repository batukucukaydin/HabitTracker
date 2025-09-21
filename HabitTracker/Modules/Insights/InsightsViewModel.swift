//
//  InsightsViewModel.swift
//  HabitTracker
//
//  Created by Batuhan Kucukaydın on 21.09.2025.
//


import SwiftUI
import Charts

struct InsightsViewModel { let weekly: [CGFloat]; let monthlySeries: [MonthlyData] }
struct MonthlyData: Identifiable { let id = UUID(); let date: Date; let value: Int }

protocol InsightsBusinessLogic { func load() async }
protocol InsightsPresentationLogic { func present(weekly: [Int], monthly: [(Date, Int)]) }

final class InsightsInteractor: InsightsBusinessLogic {
    private let repo: HabitRepositoryProtocol
    private let presenter: InsightsPresentationLogic
    init(repo: HabitRepositoryProtocol, presenter: InsightsPresentationLogic) { self.repo = repo; self.presenter = presenter }

    func load() async {
        do {
            let habits = try repo.fetchAll()
            let cal = Calendar.current
            // Weekly: sum of completions per day for last 7 days
            var weekly: [Int] = []
            for offset in (0..<7).reversed() {
                let day = cal.startOfDay(for: Date().addingTimeInterval(TimeInterval(-86400 * offset)))
                let sum = habits.reduce(0) { partial, h in
                    let hist = h.history
                    let v = hist[day] ?? 0
                    return partial + v + (cal.isDateInToday(day) ? h.completedToday : 0)
                }
                weekly.append(sum)
            }
            // Monthly trend: naive – last 30 days total
            var monthly: [(Date, Int)] = []
            for offset in (0..<30).reversed() {
                let day = cal.startOfDay(for: Date().addingTimeInterval(TimeInterval(-86400 * offset)))
                let sum = habits.reduce(0) { $0 + ($1.history[day] ?? 0) }
                monthly.append((day, sum))
            }
            presenter.present(weekly: weekly, monthly: monthly)
        } catch { presenter.present(weekly: [], monthly: []) }
    }
}

final class InsightsPresenter: ObservableObject, InsightsPresentationLogic {
    @Published var vm = InsightsViewModel(weekly: [], monthlySeries: [])
    func present(weekly: [Int], monthly: [(Date, Int)]) {
        let w = weekly.map { CGFloat($0) }
        let m = monthly.map { MonthlyData(date: $0.0, value: $0.1) }
        DispatchQueue.main.async { self.vm = InsightsViewModel(weekly: w, monthlySeries: m) }
    }
}

enum InsightsRouter {
    static func makeView() -> some View {
        let presenter = InsightsPresenter()
        let interactor = InsightsInteractor(repo: DIContainer().habitRepo, presenter: presenter)
        return InsightsView(presenter: presenter, interactor: interactor)
    }
}

struct InsightsView: View {
    @ObservedObject var presenter: InsightsPresenter
    let interactor: InsightsBusinessLogic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Haftalık İlerleme").font(.title2.bold())
                BarChartUIKitRepresentable(values: presenter.vm.weekly)
                    .frame(height: 160)
                    .padding(.horizontal)

                Text("Aylık Trend").font(.title2.bold())
                Chart(presenter.vm.monthlySeries) { item in
                    LineMark(x: .value("Tarih", item.date), y: .value("Toplam", item.value))
                    PointMark(x: .value("Tarih", item.date), y: .value("Toplam", item.value))
                }
                .frame(height: 220)
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .task { await interactor.load() }
    }
}
