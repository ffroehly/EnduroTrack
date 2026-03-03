// ExerciseSessionService.swift
// EnduroTrack › Data › Services

import Foundation
import Domain

/// Implements exercise session use cases by delegating to ExerciseSessionRepositoryProtocol.
final class ExerciseSessionService:
    FetchExerciseSessionsUseCaseProtocol,
    SaveExerciseSessionUseCaseProtocol,
    DeleteExerciseSessionUseCaseProtocol {

    private let repository: ExerciseSessionRepositoryProtocol

    init(repository: ExerciseSessionRepositoryProtocol) {
        self.repository = repository
    }

    func fetchAll() async throws -> [ExerciseSession] {
        try await repository.fetchAll()
    }

    func save(session: ExerciseSession) async throws -> ExerciseSession {
        try await repository.save(session)
    }

    func delete(sessionID: UUID) async throws {
        try await repository.delete(id: sessionID)
    }
}
