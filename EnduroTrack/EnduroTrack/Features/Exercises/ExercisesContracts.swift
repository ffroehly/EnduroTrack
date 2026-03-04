// ExercisesContracts.swift
// EnduroTrack › Features › Exercises

import Foundation
import Domain
import Combine

// MARK: - View Protocol

@MainActor
protocol ExercisesViewProtocol: AnyObject {
    func render(state: ExercisesViewState)
}

// MARK: - Presenter Protocol

@MainActor
protocol ExercisesPresenterProtocol: AnyObject {
    func viewDidAppear() async
    func didTapCreateExercise()
    func didTapDeleteExercise(id: UUID)
    func didTapEditExercise(_ exercise: Exercise)
    func didTapStartExercise(_ exercise: Exercise)
    func didSaveNewExercise(title: String, warmupSeconds: Int, activeSeconds: Int, restSeconds: Int, repetitions: Int, recoverySeconds: Int?)
    func didSaveEditedExercise(_ exercise: Exercise, title: String, warmupSeconds: Int, activeSeconds: Int, restSeconds: Int, repetitions: Int, recoverySeconds: Int?)
    func didTapPauseTimer()
    func didTapResumeTimer()
    func didTapStopTimer()
    func didTapPreviousStep()
    func didTapNextStep()
}

// MARK: - Interactor Protocol

protocol ExercisesInteractorProtocol: AnyObject {
    func fetchExercises() async throws -> [Exercise]
    func createExercise(title: String, warmupSeconds: Int, activeSeconds: Int, restSeconds: Int, repetitions: Int, recoverySeconds: Int?) async throws -> Exercise
    func updateExercise(_ exercise: Exercise) async throws -> Exercise
    func deleteExercise(id: UUID) async throws
    func saveSession(_ session: ExerciseSession) async throws -> ExerciseSession
}

// MARK: - Router Protocol

@MainActor
protocol ExercisesRouterProtocol: AnyObject {
    // No external navigation needed for now
}

// MARK: - View State

/// Phase of the timer when it's running.
enum TimerPhase: Equatable {
    case warmup
    case active(rep: Int)
    case rest(rep: Int)
    case recovery
}

enum ExercisesViewState: Equatable {
    case loading
    case list(exercises: [Exercise])
    case empty
    case showingCreateForm
    case showingEditForm(exercise: Exercise)
    case timerRunning(exercise: Exercise, phase: TimerPhase, remainingSeconds: Int, elapsedSeconds: Int)
    case timerPaused(exercise: Exercise, phase: TimerPhase, remainingSeconds: Int, elapsedSeconds: Int)
    case timerFinished(exercise: Exercise, durationSeconds: Int)
    case error(message: String)
}
