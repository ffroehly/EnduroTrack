// WorkoutExercise.swift
// Domain
//
// Legacy entity representing a single exercise within a workout session (sets-based).

import Foundation

/// Represents a single exercise performed during a workout (sets-based).
/// This is a Domain entity — pure data with no framework dependencies.
public struct WorkoutExercise: Identifiable, Equatable, Hashable, Sendable {

    public let id: UUID
    public let name: String
    public let sets: [WorkoutExerciseSet]
    public let notes: String?

    public init(
        id: UUID = UUID(),
        name: String,
        sets: [WorkoutExerciseSet] = [],
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.sets = sets
        self.notes = notes
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Represents a single set within an exercise (e.g. 3 x 10 reps at 80kg).
public struct WorkoutExerciseSet: Identifiable, Equatable, Sendable {

    public let id: UUID
    public let reps: Int?
    public let weightKg: Double?
    public let durationSeconds: Int?

    public init(
        id: UUID = UUID(),
        reps: Int? = nil,
        weightKg: Double? = nil,
        durationSeconds: Int? = nil
    ) {
        self.id = id
        self.reps = reps
        self.weightKg = weightKg
        self.durationSeconds = durationSeconds
    }
}
