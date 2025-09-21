//
//  DashboardViewModel.swift
//  HabitTracker
//
//


import SwiftUI

// Entity (ViewModel contracts)
struct DashboardViewModel {
    var progress: Double // 0..1
    var quote: String
}

protocol DashboardBusinessLogic { func load() async; func markHabit(_ id: UUID) async }
protocol DashboardPresentationLogic { func present(progress: Double, quote: String) }
protocol DashboardRoutingLogic {}

final class DashboardInteractor: DashboardBusinessLogic {
    private let repo: HabitRepositoryProtocol
    private let presenter: DashboardPresentationLogic
    init(repo: HabitRepositoryProtocol, presenter: DashboardPresentationLogic) { self.repo = repo; self.presenter = presenter }

    func load() async {
        do {
            try repo.resetTodayCountsIfNeeded()
            let habits = try repo.fetchAll()
            let total = habits.reduce(0) { $0 + $1.targetPerDay }
            let done = habits.reduce(0) { $0 + $1.completedToday }
            let progress = total == 0 ? 0 : Double(done) / Double(total)
            let quote = Self.randomQuote()
            presenter.present(progress: progress, quote: quote)
        } catch {
            presenter.present(progress: 0, quote: "Bugün küçük bir adım bile ilerlemedir ✨")
        }
    }

    func markHabit(_ id: UUID) async {
        do { try repo.toggleComplete(id); await load() } catch { }
    }

    private static func randomQuote() -> String {
        [
            "Disiplin, motivasyonu yener.",
            "Küçük adımlar büyük değişimlere yol açar.",
            "Bugün yaptığın, yarınını belirler."
        ].randomElement()!
    }
}

final class DashboardPresenter: ObservableObject, DashboardPresentationLogic {
    @Published var viewModel = DashboardViewModel(progress: 0, quote: "…")
    func present(progress: Double, quote: String) {
        DispatchQueue.main.async { self.viewModel.progress = progress; self.viewModel.quote = quote }
    }
}

enum DashboardRouter {
    static func makeView() -> some View {
        let presenter = DashboardPresenter()
        let interactor = DashboardInteractor(repo: DIContainer().habitRepo, presenter: presenter)
        return DashboardView(presenter: presenter, interactor: interactor)
    }
}

struct DashboardView: View {
    @ObservedObject var presenter: DashboardPresenter
    let interactor: DashboardBusinessLogic
    @State private var confettiCoord = ConfettiView.Coordinator()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                AnimatedBrand().padding(.top, 8)

                ZStack {
                    ProgressRingView(progress: presenter.viewModel.progress)
                        .frame(width: 240, height: 240)
                        .tint(Theme.brandOrange)
                        .shadow(color: Theme.brandOrange.opacity(0.35), radius: 22)
                    VStack(spacing: 8) {
                        Text("%\(Int(presenter.viewModel.progress * 100))")
                            .font(.system(size: 48, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 8)
                        Text(presenter.viewModel.quote)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal)
                    }
                    ConfettiView().frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .onChange(of: presenter.viewModel.progress) { _, v in
                    if v >= 1 { Haptics.success(); ConfettiView.trigger(confettiCoord) }
                }

                HStack(spacing: 12) {
                    InfoPill(title: "Günlük hedef", value: "disiplin")
                    InfoPill(title: "Seri", value: "🔥 3 gün")
                    InfoPill(title: "Toplam", value: "42 tamam")
                }
                .padding(.horizontal)
            }
        }
        .background(Theme.appBackground.ignoresSafeArea())
        .task { await interactor.load() }
    }
}

struct InfoPill: View {
    var title: String; var value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased()).font(.caption2).foregroundStyle(.white.opacity(0.6))
            Text(value).font(.footnote.bold()).foregroundStyle(.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.cardGradient)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardStroke, lineWidth: 1))
                .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 10)
        )
    }
}
