// WorkoutRepository.swift
// EnduroTrack › Data › Repositories
//
// Concrete implementation of WorkoutRepositoryProtocol.
// This is the Data layer — it knows HOW to fetch/store data.
// Currently uses an in-memory store as a placeholder.
// Replace the storage mechanism (CoreData, API) without touching the Domain or Features.
//
// SOLID: Open/Closed — swap storage by creating a new conforming type, not modifying this.
// SOLID: Dependency Inversion — depends on Domain protocols, not concrete implementations.

import Foundation
import Domain

/// In-memory implementation of WorkoutRepositoryProtocol.
/// Replace or extend with a CoreData or API-backed version when ready.
final class WorkoutRepository: WorkoutRepositoryProtocol {

    // MARK: - Private Storage

    private var store: [UUID: Workout] = [:]

    // MARK: - WorkoutRepositoryProtocol

    func fetchAll() async throws -> [Workout] {
        return Array(store.values).sorted { $0.startedAt > $1.startedAt }
    }

    func save(_ workout: Workout) async throws -> Workout {
        store[workout.id] = workout
        return workout
    }

    func update(_ workout: Workout) async throws -> Workout {
        guard store[workout.id] != nil else {
            throw RepositoryError.notFound(id: workout.id)
        }
        store[workout.id] = workout
        return workout
    }

    func delete(id: UUID) async throws {
        guard store[id] != nil else {
            throw RepositoryError.notFound(id: id)
        }
        store.removeValue(forKey: id)
    }
}
