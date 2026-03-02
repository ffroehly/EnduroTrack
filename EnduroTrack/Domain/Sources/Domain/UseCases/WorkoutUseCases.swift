//
//  WorkoutUseCases.swift
//  Domain
//

import Foundation

// MARK: - Repository Protocol (Interface Segregation Principle)

/// Contract that any Workout data source must fulfil.
/// Defined in Domain so the Data layer depends on Domain, not the reverse.
public protocol WorkoutRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [Workout]
    func save(_ workout: Workout) async throws
    func delete(id: UUID) async throws
}

// MARK: - Use Cases

/// Encapsulates the business rule for fetching all workouts.
public struct FetchWorkoutsUseCase: Sendable {
    private let repository: any WorkoutRepositoryProtocol

    public init(repository: any WorkoutRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Workout] {
        try await repository.fetchAll()
    }
}

/// Encapsulates the business rule for saving a new workout.
public struct SaveWorkoutUseCase: Sendable {
    private let repository: any WorkoutRepositoryProtocol

    public init(repository: any WorkoutRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(_ workout: Workout) async throws {
        // Business validation lives here, not in the repository
        guard !workout.name.isEmpty else {
            throw WorkoutError.invalidName
        }
        try await repository.save(workout)
    }
}

// MARK: - Domain Errors

public enum WorkoutError: Error, Equatable {
    case invalidName
    case notFound(UUID)
    case saveFailed
}
