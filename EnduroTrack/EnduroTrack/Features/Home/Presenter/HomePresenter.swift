// HomePresenter.swift
// EnduroTrack › Features › Home

import Foundation
import Domain
import Combine

@MainActor
final class HomePresenter: ObservableObject, HomePresenterProtocol {

    @Published private(set) var state: HomeViewState = .loading

    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidAppear() async {
        state = .loading
        do {
            async let nextTask = interactor.fetchNextScheduledExercise()
            async let sessionsTask = interactor.fetchRecentSessions(limit: 5)
            let (next, sessions) = try await (nextTask, sessionsTask)
            state = .loaded(nextExercise: next, recentSessions: sessions)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    func didTapGoToSchedule() {
        router.navigateToSchedule()
    }

    func didTapStartExercise(exerciseId: UUID) {
        router.navigateToExercises()
    }
}
