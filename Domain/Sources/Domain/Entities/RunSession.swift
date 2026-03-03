// RunSession.swift
// Domain
//
// Entity representing a running session with GPS and pace data.

import Foundation

/// Represents a running session tracked by the app.
/// This is a Domain entity — pure data with no framework dependencies.
public struct RunSession: Identifiable, Equatable, Hashable, Sendable {

    public let id: UUID
    public let startedAt: Date
    public let finishedAt: Date?
    public let distanceMeters: Double
    public let durationSeconds: Int
    public let averagePaceSecondsPerKm: Double?
    public let calories: Int?
    public let route: [RoutePoint]

    public init(
        id: UUID = UUID(),
        startedAt: Date,
        finishedAt: Date? = nil,
        distanceMeters: Double,
        durationSeconds: Int,
        averagePaceSecondsPerKm: Double? = nil,
        calories: Int? = nil,
        route: [RoutePoint] = []
    ) {
        self.id = id
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.distanceMeters = distanceMeters
        self.durationSeconds = durationSeconds
        self.averagePaceSecondsPerKm = averagePaceSecondsPerKm
        self.calories = calories
        self.route = route
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// A single GPS coordinate point captured during a run.
public struct RoutePoint: Equatable, Sendable {

    public let latitude: Double
    public let longitude: Double
    public let altitude: Double?
    public let timestamp: Date

    public init(
        latitude: Double,
        longitude: Double,
        altitude: Double? = nil,
        timestamp: Date
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
    }
}
