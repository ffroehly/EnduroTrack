// ExerciseService.swift
// EnduroTrack › Data › Services

import Foundation
import Domain

/// Implements exercise use cases by delegating to ExerciseRepositoryProtocol.
final class ExerciseService:
    FetchExercisesUseCaseProtocol,
    CreateExerciseUseCaseProtocol,
    UpdateExerciseUseCaseProtocol,
    DeleteExerciseUseCaseProtocol {

    private let repository: ExerciseRepositoryProtocol

    init(repository: ExerciseRepositoryProtocol) {
        self.repository = repository
    }

    func fetchAll() async throws -> [Exercise] {
        try await repository.fetchAll()
    }

    func create(exercise: Exercise) async throws -> Exercise {
        try await repository.save(exercise)
    }

    func update(exercise: Exercise) async throws -> Exercise {
        try await repository.update(exercise)
    }

    func delete(exerciseID: UUID) async throws {
        try await repository.delete(id: exerciseID)
    }
}
