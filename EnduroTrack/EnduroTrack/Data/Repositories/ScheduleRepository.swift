// ScheduleRepository.swift
// EnduroTrack › Data › Repositories

import Foundation
import Domain

/// JSON-persisted implementation of ScheduleRepositoryProtocol.
final class ScheduleRepository: ScheduleRepositoryProtocol {

    private let store: FileStore<Schedule>
    private var cache: [UUID: Schedule] = [:]
    private var loaded = false

    init() {
        store = FileStore(filename: "schedules.json")
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

    func fetchAll() async throws -> [Schedule] {
        try loadIfNeeded()
        return Array(cache.values).sorted { $0.createdAt < $1.createdAt }
    }

    func save(_ schedule: Schedule) async throws -> Schedule {
        try loadIfNeeded()
        cache[schedule.id] = schedule
        try persist()
        return schedule
    }

    func update(_ schedule: Schedule) async throws -> Schedule {
        try loadIfNeeded()
        guard cache[schedule.id] != nil else {
            throw RepositoryError.notFound(id: schedule.id)
        }
        cache[schedule.id] = schedule
        try persist()
        return schedule
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
