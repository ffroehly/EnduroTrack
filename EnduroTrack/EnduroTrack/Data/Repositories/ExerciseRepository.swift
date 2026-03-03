// ExerciseRepository.swift
// EnduroTrack › Data › Repositories

import Foundation
import Domain

/// JSON-persisted implementation of ExerciseRepositoryProtocol.
final class ExerciseRepository: ExerciseRepositoryProtocol {

    private let store: FileStore<Exercise>
    private var cache: [UUID: Exercise] = [:]
    private var loaded = false

    init() {
        store = FileStore(filename: "exercises.json")
    }

    private func loadIfNeeded() throws {
        guard !loaded else { return }
        let items = try store.load()
        cache = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        loaded = true
    }

    private func persist() throws {
        let items = Array(cache.values).sorted { $0.createdAt < $1.createdAt }
        try store.save(items)
    }

    func fetchAll() async throws -> [Exercise] {
        try loadIfNeeded()
        return Array(cache.values).sorted { $0.createdAt < $1.createdAt }
    }

    func save(_ exercise: Exercise) async throws -> Exercise {
        try loadIfNeeded()
        cache[exercise.id] = exercise
        try persist()
        return exercise
    }

    func update(_ exercise: Exercise) async throws -> Exercise {
        try loadIfNeeded()
        guard cache[exercise.id] != nil else {
            throw RepositoryError.notFound(id: exercise.id)
        }
        cache[exercise.id] = exercise
        try persist()
        return exercise
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
