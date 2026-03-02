//
//  Workout.swift
//  Domain
//

import Foundation

/// A single training session performed by the user.
///
/// Entity – has a unique identity (id) and can change over time.
/// No UI, no network, no persistence details live here.
public struct Workout: Identifiable, Equatable, Sendable {

    public let id: UUID

    /// User-facing name of the workout (e.g. "Morning Strength").
    public var name: String

    /// Optional description / notes.
    public var notes: String?

    /// Total duration of the workout.
    public var duration: Duration

    /// Difficulty perceived by the user.
    public var difficulty: DifficultyLevel

    /// ISO-8601 date when the workout was performed.
    public var performedAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        notes: String? = nil,
        duration: Duration,
        difficulty: DifficultyLevel,
        performedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.notes = notes
        self.duration = duration
        self.difficulty = difficulty
        self.performedAt = performedAt
    }
}
