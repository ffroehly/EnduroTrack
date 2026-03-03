// WorkoutInteractor.swift
// EnduroTrack › Features › Workout › Interactor
//
// VIPER: Interactor layer for the Workout module.
// Contains business logic: creating, updating, and finishing workouts.

import Foundation
import Domain

/// Handles business logic for the Workout feature.
final class WorkoutInteractor: WorkoutInteractorProtocol {

    // MARK: - Dependencies

    private let createWorkoutUseCase: CreateWorkoutUseCaseProtocol
    private let updateWorkoutUseCase: UpdateWorkoutUseCaseProtocol

    // MARK: - Init

    init(
        createWorkoutUseCase: CreateWorkoutUseCaseProtocol,
        updateWorkoutUseCase: UpdateWorkoutUseCaseProtocol
    ) {
        self.createWorkoutUseCase = createWorkoutUseCase
        self.updateWorkoutUseCase = updateWorkoutUseCase
    }

    // MARK: - WorkoutInteractorProtocol

    func createWorkout(title: String, type: WorkoutType) async throws -> Workout {
        let workout = Workout(
            title: title,
            type: type,
            status: .inProgress,
            startedAt: Date(),
            durationSeconds: 0
        )
        return try await createWorkoutUseCase.execute(workout: workout)
    }

    func updateWorkout(_ workout: Workout) async throws -> Workout {
        try await updateWorkoutUseCase.execute(workout: workout)
    }

    func finishWorkout(_ workout: Workout) async throws -> Workout {
        let finished = Workout(
            id: workout.id,
            title: workout.title,
            type: workout.type,
            status: .completed,
            startedAt: workout.startedAt,
            finishedAt: Date(),
            durationSeconds: Int(Date().timeIntervalSince(workout.startedAt)),
            exercises: workout.exercises
        )
        return try await updateWorkoutUseCase.execute(workout: finished)
    }
}
