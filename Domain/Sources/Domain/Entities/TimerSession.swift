// TimerSession.swift
// Domain
//
// Entity representing an interval timer session.

import Foundation

/// Represents a timer / interval training session.
/// This is a Domain entity — pure data with no framework dependencies.
public struct TimerSession: Identifiable, Equatable, Sendable {

    public let id: UUID
    public let name: String
    public let intervals: [TimerInterval]
    public let repeatCount: Int
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        intervals: [TimerInterval],
        repeatCount: Int = 1,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.intervals = intervals
        self.repeatCount = repeatCount
        self.createdAt = createdAt
    }
}

/// Represents a single interval within a timer session (e.g. 30s work, 10s rest).
public struct TimerInterval: Identifiable, Equatable, Sendable {

    public enum IntervalType: String, Equatable, Sendable {
        case work
        case rest
        case warmUp
        case coolDown
    }

    public let id: UUID
    public let type: IntervalType
    public let durationSeconds: Int
    public let label: String?

    public init(
        id: UUID = UUID(),
        type: IntervalType,
        durationSeconds: Int,
        label: String? = nil
    ) {
        self.id = id
        self.type = type
        self.durationSeconds = durationSeconds
        self.label = label
    }
}
