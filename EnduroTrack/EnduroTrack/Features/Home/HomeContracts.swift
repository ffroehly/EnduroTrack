// HomeContracts.swift
// EnduroTrack › Features › Home

import Foundation
import Domain
import Combine

@MainActor
protocol HomeViewProtocol: AnyObject {
    func render(state: HomeViewState)
}

@MainActor
protocol HomePresenterProtocol: AnyObject {
    func viewDidAppear() async
    func didTapGoToSchedule()
    func didTapStartExercise(exerciseId: UUID)
}

protocol HomeInteractorProtocol: AnyObject {
    func fetchNextScheduledExercise() async throws -> NextExerciseInfo?
    func fetchRecentSessions(limit: Int) async throws -> [ExerciseSession]
}

@MainActor
protocol HomeRouterProtocol: AnyObject {
    func navigateToSchedule()
    func navigateToExercises()
}

/// Information about the next upcoming scheduled exercise.
struct NextExerciseInfo: Equatable {
    let exerciseId: UUID
    let exerciseTitle: String
    let dayOfWeek: DayOfWeek
    let reminderTimeFormatted: String
    /// True if this exercise is scheduled for today.
    let isToday: Bool
}

enum HomeViewState: Equatable {
    case loading
    case loaded(nextExercise: NextExerciseInfo?, recentSessions: [ExerciseSession])
    case error(message: String)
}
