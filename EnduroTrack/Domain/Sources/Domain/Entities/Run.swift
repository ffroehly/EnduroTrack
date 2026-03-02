//
//  Run.swift
//  Domain
//

import Foundation

/// A single running session.
///
/// Entity – has a unique identity (id) and represents a completed run.
public struct Run: Identifiable, Equatable, Sendable {

    public let id: UUID

    /// User-facing label (e.g. "Evening 5K").
    public var name: String

    /// Total distance covered.
    public var distance: Distance

    /// Total time taken.
    public var duration: Duration

    /// Average pace (seconds per kilometre or mile).
    public var averagePace: Double

    /// When the run was performed.
    public var performedAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        distance: Distance,
        duration: Duration,
        averagePace: Double,
        performedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.distance = distance
        self.duration = duration
        self.averagePace = averagePace
        self.performedAt = performedAt
    }
}
