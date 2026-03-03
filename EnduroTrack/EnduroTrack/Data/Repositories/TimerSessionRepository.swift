// TimerSessionRepository.swift
// EnduroTrack › Data › Repositories
//
// Concrete implementation of TimerSessionRepositoryProtocol.
// Currently uses an in-memory store as a placeholder.

import Foundation
import Domain

/// In-memory implementation of TimerSessionRepositoryProtocol.
final class TimerSessionRepository: TimerSessionRepositoryProtocol {

    // MARK: - Private Storage

    private var store: [UUID: TimerSession] = [:]

    // MARK: - TimerSessionRepositoryProtocol

    func fetchAll() async throws -> [TimerSession] {
        return Array(store.values).sorted { $0.createdAt > $1.createdAt }
    }

    func save(_ session: TimerSession) async throws -> TimerSession {
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
