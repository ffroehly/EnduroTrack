// TimerSessionRepositoryProtocol.swift
// Domain
//
// Repository protocol for timer sessions. Lives in the Domain layer.
//
// SOLID: Dependency Inversion — Domain defines the interface; Data implements it.

import Foundation

/// Abstraction over the data source for timer sessions / presets.
/// Implemented in the Data layer (e.g. CoreData, API, in-memory).
public protocol TimerSessionRepositoryProtocol: Sendable {
    /// Fetches all timer session presets from the data source.
    func fetchAll() async throws -> [TimerSession]

    /// Saves a timer session preset to the data source and returns the persisted version.
    func save(_ session: TimerSession) async throws -> TimerSession

    /// Deletes the timer session preset with the given ID from the data source.
    func delete(id: UUID) async throws
}
