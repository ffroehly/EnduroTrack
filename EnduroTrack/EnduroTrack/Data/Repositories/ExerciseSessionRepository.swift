// ExerciseSessionRepository.swift
// EnduroTrack › Data › Repositories

import Foundation
import Domain

/// JSON-persisted implementation of ExerciseSessionRepositoryProtocol.
final class ExerciseSessionRepository: ExerciseSessionRepositoryProtocol {

    private let store: FileStore<ExerciseSession>
    private var cache: [UUID: ExerciseSession] = [:]
    private var loaded = false

    init() {
        store = FileStore(filename: "exercise_sessions.json")
    }

    private func loadIfNeeded() throws {
        guard !loaded else { return }
        let items = try store.load()
        cache = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        loaded = true
    }

    private func persist() throws {
        let items = Array(cache.values).sorted { $0.completedAt > $1.completedAt }
        try store.save(items)
    }

    func fetchAll() async throws -> [ExerciseSession] {
        try loadIfNeeded()
        return Array(cache.values).sorted { $0.completedAt > $1.completedAt }
    }

    func save(_ session: ExerciseSession) async throws -> ExerciseSession {
        try loadIfNeeded()
        cache[session.id] = session
        try persist()
        return session
    }

    func delete(id: UUID) async throws {
        try loadIfNeeded()
        guard cache[id] != nil else {
            throw RepositoryError.notFound(id: id)
        }
        cache.removeValue(forKey: id)
        try persist()
    }
}
