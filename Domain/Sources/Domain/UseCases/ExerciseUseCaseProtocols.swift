// ExerciseUseCaseProtocols.swift
// Domain

import Foundation

public protocol FetchExercisesUseCaseProtocol: Sendable {
    func fetchAll() async throws -> [Exercise]
}

public protocol CreateExerciseUseCaseProtocol: Sendable {
    func create(exercise: Exercise) async throws -> Exercise
}

public protocol UpdateExerciseUseCaseProtocol: Sendable {
    func update(exercise: Exercise) async throws -> Exercise
}

public protocol DeleteExerciseUseCaseProtocol: Sendable {
    func delete(exerciseID: UUID) async throws
}
