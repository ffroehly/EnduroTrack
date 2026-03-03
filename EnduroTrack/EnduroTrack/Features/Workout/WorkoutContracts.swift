// WorkoutContracts.swift
// EnduroTrack › Features › Workout
//
// VIPER contracts for the Workout module.
// Defines all inter-layer communication protocols.

import Foundation
import Domain

// MARK: - View Protocol

@MainActor
protocol WorkoutViewProtocol: AnyObject {
    func render(state: WorkoutViewState)
}

// MARK: - Presenter Protocol

@MainActor
protocol WorkoutPresenterProtocol: AnyObject {
    func viewDidAppear() async
    func didTapStartWorkout(title: String, type: WorkoutType)
    func didSelectExercise(_ exercise: Exercise)
    func didTapFinishWorkout()
}

// MARK: - Interactor Protocol

protocol WorkoutInteractorProtocol: AnyObject {
    func createWorkout(title: String, type: WorkoutType) async throws -> Workout
    func updateWorkout(_ workout: Workout) async throws -> Workout
    func finishWorkout(_ workout: Workout) async throws -> Workout
}

// MARK: - Router Protocol

@MainActor
protocol WorkoutRouterProtocol: AnyObject {
    func navigateToExerciseDetail(_ exercise: Exercise)
    func dismissWorkout()
}

// MARK: - View State

enum WorkoutViewState: Equatable {
    case idle
    case loading
    case active(workout: Workout)
    case finished(workout: Workout)
    case error(message: String)
}
