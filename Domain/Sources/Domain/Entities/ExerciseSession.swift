// ExerciseSession.swift
// Domain
//
// Entity representing a completed exercise session (when timer was active).

import Foundation

/// Represents a completed exercise session.
/// A session is recorded only when the timer is actually run (not just scheduled).
public struct ExerciseSession: Identifiable, Equatable, Sendable, Codable {

    public let id: UUID
    /// The ID of the exercise that was performed.
    public let exerciseId: UUID
    /// Snapshot of the exercise title at the time of the session.
    public let exerciseTitle: String
    /// When the session was completed.
    public let completedAt: Date
    /// Actual duration the timer was active (in seconds).
    public let durationSeconds: Int
    
    public var durationMinutes: Int {
        durationSeconds / 60
    }

    public init(
        id: UUID = UUID(),
        exerciseId: UUID,
        exerciseTitle: String,
        completedAt: Date = Date(),
        durationSeconds: Int
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.exerciseTitle = exerciseTitle
        self.completedAt = completedAt
        self.durationSeconds = durationSeconds
    }
}
