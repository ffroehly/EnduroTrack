// TimerUseCaseProtocols.swift
// Domain
//
// Defines the interface for all timer-session-related business use cases.
//
// SOLID: Interface Segregation — each use case protocol is focused and small.
// SOLID: Dependency Inversion — high-level modules depend on this abstraction, not concrete types.

import Foundation

/// Defines all read operations for timer sessions.
public protocol FetchTimerSessionsUseCaseProtocol: Sendable {
    /// Fetches all stored timer sessions / presets.
    func fetchAll() async throws -> [TimerSession]
}

/// Defines the creation of a timer session preset.
public protocol CreateTimerSessionUseCaseProtocol: Sendable {
    /// Persists a new timer session preset and returns the saved instance.
    func create(session: TimerSession) async throws -> TimerSession
}

/// Defines the deletion of a timer session preset.
public protocol DeleteTimerSessionUseCaseProtocol: Sendable {
    /// Deletes the timer session preset with the specified identifier.
    func delete(sessionID: UUID) async throws
}
