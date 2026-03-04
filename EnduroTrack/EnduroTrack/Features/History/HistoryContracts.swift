// HistoryContracts.swift
// EnduroTrack › Features › History

import Foundation
import Domain

@MainActor
protocol HistoryViewProtocol: AnyObject {
    func render(state: HistoryViewState)
}

@MainActor
protocol HistoryPresenterProtocol: AnyObject {
    func viewDidAppear() async
    func didTapPreviousMonth()
    func didTapNextMonth()
}

protocol HistoryInteractorProtocol: AnyObject {
    func fetchAllSessions() async throws -> [ExerciseSession]
}

@MainActor
protocol HistoryRouterProtocol: AnyObject {}

/// A data point for the monthly chart: one bar per day that had sessions.
struct DailySessionSummary: Identifiable, Equatable {
    let id: Date
    let date: Date
    let totalDurationMinutes: Int
    let sessionCount: Int
}

enum HistoryViewState: Equatable {
    case loading
    case loaded(sessions: [ExerciseSession], monthlySummaries: [DailySessionSummary], selectedMonth: Date)
    case empty
    case error(message: String)
}
