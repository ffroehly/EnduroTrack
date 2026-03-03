// Exercise.swift
// Domain
//
// Entity representing a timer-based exercise.

import Foundation

/// Represents a timer-based exercise definition.
/// Contains the timer configuration: warmup, active/rest cycles, and optional recovery.
public struct Exercise: Identifiable, Equatable, Hashable, Sendable, Codable {

    public let id: UUID
    public let title: String
    /// Warmup duration in seconds before the first active interval. Default: 5.
    public let warmupSeconds: Int
    /// Active (work) duration in seconds per repetition.
    public let activeSeconds: Int
    /// Rest duration in seconds per repetition.
    public let restSeconds: Int
    /// Number of repetitions. One rep = activeSeconds + restSeconds.
    public let repetitions: Int
    /// Optional recovery period in seconds at the end.
    public let recoverySeconds: Int?
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        warmupSeconds: Int = 5,
        activeSeconds: Int,
        restSeconds: Int,
        repetitions: Int,
        recoverySeconds: Int? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.warmupSeconds = warmupSeconds
        self.activeSeconds = activeSeconds
        self.restSeconds = restSeconds
        self.repetitions = repetitions
        self.recoverySeconds = recoverySeconds
        self.createdAt = createdAt
    }

    /// Total expected duration in seconds.
    public var totalDurationSeconds: Int {
        warmupSeconds + (activeSeconds + restSeconds) * repetitions + (recoverySeconds ?? 0)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
