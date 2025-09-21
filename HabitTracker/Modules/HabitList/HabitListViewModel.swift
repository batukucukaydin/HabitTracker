//
//  HabitListViewModel.swift
//  HabitTracker
//
//


import SwiftUI

struct HabitListViewModel: Identifiable { let id: UUID; let title: String; let icon: String; let filledIcon: String; let progressText: String; let isDone: Bool }
protocol HabitListBusinessLogic { func load() async; func add(title: String, icon: String, target: Int) async; func toggle(id: UUID) async; func delete(id: UUID) async }
protocol HabitListPresentationLogic { func present(habits: [HabitDTO]) }

final class HabitListInteractor: HabitListBusinessLogic {
    private let repo: HabitRepositoryProtocol
    private let presenter: HabitListPresentationLogic
    init(repo: HabitRepositoryProtocol, presenter: HabitListPresentationLogic) { self.repo = repo; self.presenter = presenter }

    func load() async { do { try repo.resetTodayCountsIfNeeded(); presenter.present(habits: try repo.fetchAll()) } catch { } }
    func add(title: String, icon: String, target: Int) async { do { try repo.add(title: title, icon: icon, targetPerDay: target); await load() } catch { } }
    func toggle(id: UUID) async { do { try repo.toggleComplete(id); await load() } catch { } }
    func delete(id: UUID) async { do { try repo.delete(id); await load() } catch { } }
}

final class HabitListPresenter: ObservableObject, HabitListPresentationLogic {
    @Published var items: [HabitListViewModel] = []
    func present(habits: [HabitDTO]) {
        let mapped = habits.map { h in
            HabitListViewModel(
                id: h.id,
                title: h.title,
                icon: h.icon,
                filledIcon: h.icon + ".fill",
                progressText: "\(h.completedToday)/\(h.targetPerDay)",
                isDone: h.completedToday >= h.targetPerDay
            )
        }
        DispatchQueue.main.async { self.items = mapped }
    }
}

enum HabitListRouter {
    static func makeView() -> some View {
        let presenter = HabitListPresenter()
        let interactor = HabitListInteractor(repo: DIContainer().habitRepo, presenter: presenter)
        return HabitListView(presenter: presenter, interactor: interactor)
    }
}

struct HabitListView: View {
    @ObservedObject var presenter: HabitListPresenter
    let interactor: HabitListBusinessLogic
    @State private var newTitle: String = ""
    @State private var newTarget: Int = 1
    @State private var newIcon: String = "drop"

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack { TextField("Yeni alışkanlık", text: $newTitle); Stepper(value: $newTarget, in: 1...20) { Text("Hedef: \(newTarget)") } }
                    HStack { Text("İkon" ); TextField("SF Symbol", text: $newIcon) }
                    Button("Ekle") { Task { await interactor.add(title: newTitle, icon: newIcon, target: newTarget); newTitle="" } }
                }
                Section {
                    ForEach(presenter.items) { vm in
                        HabitCard(vm: vm) {
                            Task { await interactor.toggle(id: vm.id) }
                        }
                        .swipeActions(content: {
                            Button(role: .destructive) { Task { await interactor.delete(id: vm.id) } } label: { Label("Sil", systemImage: "trash") }
                        })
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Theme.appBackground)
            .navigationTitle("Alışkanlıklar")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Theme.tabBarBackground, for: .navigationBar)
            .task { await interactor.load() }
        }
        .background(Theme.appBackground.ignoresSafeArea())
    }
}

struct HabitCard: View {
    let vm: HabitListViewModel
    let onToggle: () -> Void
    @State private var isOn: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isOn ? vm.filledIcon : vm.icon)
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 32, height: 32)
                .scaleEffect(isOn ? 1.15 : 1)
                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isOn)

            VStack(alignment: .leading) {
                Text(vm.title).font(.headline)
                Text(vm.progressText).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: Binding(get: { isOn }, set: { val in isOn = val; onToggle(); Haptics.impact(.light) }))
                .labelsHidden()
                .toggleStyle(BouncyToggleStyle(icon: vm.icon, filledIcon: vm.filledIcon))
        }
        .padding(.vertical, 6)
        .onAppear { isOn = vm.isDone }
    }
}
