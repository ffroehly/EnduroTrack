// RunSessionRepositoryProtocol.swift
// Domain
//
// Repository protocol for run sessions. Lives in the Domain layer.
//
// SOLID: Dependency Inversion — Domain defines the interface; Data implements it.

import Foundation

/// Abstraction over the data source for run sessions.
/// Implemented in the Data layer (e.g. CoreData, API, in-memory).
public protocol RunSessionRepositoryProtocol: Sendable {
    /// Fetches all run sessions from the data source.
    func fetchAll() async throws -> [RunSession]

    /// Saves a run session to the data source and returns the persisted version.
    func save(_ session: RunSession) async throws -> RunSession

    /// Deletes the run session with the given ID from the data source.
    func delete(id: UUID) async throws
}
