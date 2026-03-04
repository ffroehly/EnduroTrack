// HistoryPresenter.swift
// EnduroTrack › Features › History

import Foundation
import Domain
import Combine

@MainActor
final class HistoryPresenter: ObservableObject, HistoryPresenterProtocol {

    @Published private(set) var state: HistoryViewState = .loading

    private let interactor: HistoryInteractorProtocol
    private let router: HistoryRouterProtocol
    private var selectedMonth: Date = {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: comps) ?? Date()
    }()

    init(interactor: HistoryInteractorProtocol, router: HistoryRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidAppear() async {
        await loadSessions()
    }

    func didTapPreviousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
        Task { await loadSessions() }
    }

    func didTapNextMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
        Task { await loadSessions() }
    }

    private func loadSessions() async {
        state = .loading
        do {
            let allSessions = try await interactor.fetchAllSessions()
            if allSessions.isEmpty {
                state = .empty
                return
            }
            let monthlySessions = sessions(for: selectedMonth, from: allSessions)
            let summaries = dailySummaries(from: monthlySessions)
            state = .loaded(sessions: allSessions, monthlySummaries: summaries, selectedMonth: selectedMonth)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    private func sessions(for month: Date, from sessions: [ExerciseSession]) -> [ExerciseSession] {
        let calendar = Calendar.current
        return sessions.filter {
            calendar.isDate($0.completedAt, equalTo: month, toGranularity: .month)
        }
    }

    private func dailySummaries(from sessions: [ExerciseSession]) -> [DailySessionSummary] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: sessions) {
            calendar.startOfDay(for: $0.completedAt)
        }
        return grouped.map { (date, sessions) in
            DailySessionSummary(
                id: date,
                date: date,
                totalDurationSeconds: sessions.reduce(0) { $0 + $1.durationSeconds },
                sessionCount: sessions.count
            )
        }.sorted { $0.date < $1.date }
    }
}
