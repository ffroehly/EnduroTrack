// RunSessionRepository.swift
// EnduroTrack › Data › Repositories
//
// Concrete implementation of RunSessionRepositoryProtocol.
// Currently uses an in-memory store as a placeholder.
// Replace with CoreData or API-backed implementation without touching Domain or Features.

import Foundation
import Domain

/// In-memory implementation of RunSessionRepositoryProtocol.
final class RunSessionRepository: RunSessionRepositoryProtocol {

    // MARK: - Private Storage

    private var store: [UUID: RunSession] = [:]

    // MARK: - RunSessionRepositoryProtocol

    func fetchAll() async throws -> [RunSession] {
        return Array(store.values).sorted { $0.startedAt > $1.startedAt }
    }

    func save(_ session: RunSession) async throws -> RunSession {
        store[session.id] = session
        return session
    }

    func delete(id: UUID) async throws {
        guard store[id] != nil else {
            throw RepositoryError.notFound(id: id)
        }
        store.removeValue(forKey: id)
    }
}
