// WorkoutUseCaseProtocol.swift
// Domain
//
// Defines the interface for all workout-related business use cases.
// Use Case protocols live in the Domain layer and are implemented in the Data layer
// or Interactor layer. They orchestrate data flow between entities and external interfaces.
//
// SOLID: Interface Segregation — each use case protocol is focused and small.
// SOLID: Dependency Inversion — high-level modules depend on this abstraction, not concrete types.

import Foundation

/// Defines all read operations for workouts.
public protocol FetchWorkoutsUseCaseProtocol: Sendable {
    /// Fetches all stored workouts.
    func execute() async throws -> [Workout]
}

/// Defines the creation of a new workout.
public protocol CreateWorkoutUseCaseProtocol: Sendable {
    /// Persists a new workout and returns the saved instance.
    func execute(workout: Workout) async throws -> Workout
}

/// Defines the update of an existing workout.
public protocol UpdateWorkoutUseCaseProtocol: Sendable {
    /// Updates an existing workout and returns the updated instance.
    func execute(workout: Workout) async throws -> Workout
}

/// Defines the deletion of a workout.
public protocol DeleteWorkoutUseCaseProtocol: Sendable {
    /// Deletes the workout with the specified identifier.
    func execute(workoutID: UUID) async throws
}
