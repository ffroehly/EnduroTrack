// ExerciseRepositoryProtocol.swift
// Domain

import Foundation

public protocol ExerciseRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [Exercise]
    func save(_ exercise: Exercise) async throws -> Exercise
    func update(_ exercise: Exercise) async throws -> Exercise
    func delete(id: UUID) async throws
}
