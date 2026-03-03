// Workout.swift
// Domain
//
// Entity representing a workout session.
// Entities are pure Swift structs/classes with no framework dependencies.
// They represent the core business objects of the application.

import Foundation

/// Represents a complete workout session.
/// This is a Domain entity — it contains only business data and logic.
public struct Workout: Identifiable, Equatable, Hashable, Sendable {

    public let id: UUID
    public let title: String
    public let type: WorkoutType
    public let status: WorkoutStatus
    public let startedAt: Date
    public let finishedAt: Date?
    public let durationSeconds: Int
    public let exercises: [Exercise]

    public init(
        id: UUID = UUID(),
        title: String,
        type: WorkoutType,
        status: WorkoutStatus,
        startedAt: Date,
        finishedAt: Date? = nil,
        durationSeconds: Int,
        exercises: [Exercise] = []
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.status = status
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.durationSeconds = durationSeconds
        self.exercises = exercises
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
