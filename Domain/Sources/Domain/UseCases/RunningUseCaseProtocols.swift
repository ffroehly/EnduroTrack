// RunningUseCaseProtocols.swift
// Domain
//
// Defines the interface for all running-session-related business use cases.
//
// SOLID: Interface Segregation — each use case protocol is focused and small.
// SOLID: Dependency Inversion — high-level modules depend on this abstraction, not concrete types.

import Foundation

/// Defines all read operations for run sessions.
public protocol FetchRunSessionsUseCaseProtocol: Sendable {
    /// Fetches all stored run sessions.
    func fetchAll() async throws -> [RunSession]
}

/// Defines the saving of a new run session.
public protocol SaveRunSessionUseCaseProtocol: Sendable {
    /// Persists a completed run session and returns the saved instance.
    func save(session: RunSession) async throws -> RunSession
}

/// Defines the deletion of a run session.
public protocol DeleteRunSessionUseCaseProtocol: Sendable {
    /// Deletes the run session with the specified identifier.
    func delete(sessionID: UUID) async throws
}
