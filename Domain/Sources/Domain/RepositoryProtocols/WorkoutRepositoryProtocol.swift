// WorkoutRepositoryProtocol.swift
// Domain
//
// Repository protocol for workouts. Lives in the Domain layer so that the Data layer
// depends on Domain abstractions, not the other way around.
//
// SOLID: Dependency Inversion — Domain defines the interface; Data implements it.

import Foundation

/// Abstraction over the data source for workouts.
/// Implemented in the Data layer (e.g. CoreData, API, in-memory).
public protocol WorkoutRepositoryProtocol: Sendable {
    /// Fetches all workouts from the data source.
    func fetchAll() async throws -> [Workout]

    /// Saves a workout to the data source and returns the persisted version.
    func save(_ workout: Workout) async throws -> Workout

    /// Updates an existing workout in the data source.
    func update(_ workout: Workout) async throws -> Workout

    /// Deletes the workout with the given ID from the data source.
    func delete(id: UUID) async throws
}
