// ExerciseSessionRepositoryProtocol.swift
// Domain

import Foundation

public protocol ExerciseSessionRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [ExerciseSession]
    func save(_ session: ExerciseSession) async throws -> ExerciseSession
    func delete(id: UUID) async throws
}
