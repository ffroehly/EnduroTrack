// WorkoutService.swift
// EnduroTrack › Data › Services
//
// Service layer that implements workout use cases using the WorkoutRepository.
// Services sit between the Interactor (VIPER) and the Repository.
// They implement Domain use case protocols, enabling dependency injection in Interactors.
//
// SOLID: Single Responsibility — each service handles one feature area.
// SOLID: Dependency Inversion — depends on Domain protocols, injected at init.

import Foundation
import Domain

/// Implements workout use cases by delegating to WorkoutRepositoryProtocol.
final class WorkoutService:
    FetchWorkoutsUseCaseProtocol,
    CreateWorkoutUseCaseProtocol,
    UpdateWorkoutUseCaseProtocol,
    DeleteWorkoutUseCaseProtocol {

    // MARK: - Dependencies

    private let repository: WorkoutRepositoryProtocol

    // MARK: - Init

    init(repository: WorkoutRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - FetchWorkoutsUseCaseProtocol

    func execute() async throws -> [Workout] {
        try await repository.fetchAll()
    }

    // MARK: - CreateWorkoutUseCaseProtocol

    func execute(workout: Workout) async throws -> Workout {
        try await repository.save(workout)
    }

    // MARK: - UpdateWorkoutUseCaseProtocol

    func execute(workout: Workout) async throws -> Workout {
        try await repository.update(workout)
    }

    // MARK: - DeleteWorkoutUseCaseProtocol

    func execute(workoutID: UUID) async throws {
        try await repository.delete(id: workoutID)
    }
}
