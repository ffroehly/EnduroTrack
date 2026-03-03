// ExerciseSessionUseCaseProtocols.swift
// Domain

import Foundation

public protocol FetchExerciseSessionsUseCaseProtocol: Sendable {
    func fetchAll() async throws -> [ExerciseSession]
}

public protocol SaveExerciseSessionUseCaseProtocol: Sendable {
    func save(session: ExerciseSession) async throws -> ExerciseSession
}

public protocol DeleteExerciseSessionUseCaseProtocol: Sendable {
    func delete(sessionID: UUID) async throws
}
