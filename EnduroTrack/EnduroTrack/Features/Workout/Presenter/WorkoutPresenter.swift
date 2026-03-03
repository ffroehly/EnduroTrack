// WorkoutPresenter.swift
// EnduroTrack › Features › Workout › Presenter
//
// VIPER: Presenter layer for the Workout module.
// Orchestrates Interactor calls, transforms results into view state,
// and delegates navigation to the Router.

import Foundation
import Domain

/// Drives the Workout screen. Observed by WorkoutView.
@MainActor
final class WorkoutPresenter: ObservableObject, WorkoutPresenterProtocol {

    // MARK: - Published State

    @Published private(set) var state: WorkoutViewState = .idle

    // MARK: - VIPER Dependencies

    private let interactor: WorkoutInteractorProtocol
    private let router: WorkoutRouterProtocol

    // MARK: - Init

    init(interactor: WorkoutInteractorProtocol, router: WorkoutRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - WorkoutPresenterProtocol

    func viewDidAppear() async {
        state = .idle
    }

    func didTapStartWorkout(title: String, type: WorkoutType) {
        Task {
            state = .loading
            do {
                let workout = try await interactor.createWorkout(title: title, type: type)
                state = .active(workout: workout)
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didSelectExercise(_ exercise: Exercise) {
        router.navigateToExerciseDetail(exercise)
    }

    func didTapFinishWorkout() {
        guard case .active(let workout) = state else { return }
        Task {
            do {
                let finished = try await interactor.finishWorkout(workout)
                state = .finished(workout: finished)
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }
}
