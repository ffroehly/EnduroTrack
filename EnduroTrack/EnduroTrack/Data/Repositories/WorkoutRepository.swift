//
//  WorkoutRepository.swift
//  EnduroTrack
//

import Foundation
import Domain

/// Concrete implementation of WorkoutRepositoryProtocol.
/// Fetches and persists Workout data (API, CoreData, or in-memory).
///
/// Clean Architecture rule: this class lives in the Data layer and returns
/// Domain objects. The Features layer never sees networking/CoreData details.
struct WorkoutRepository: WorkoutRepositoryProtocol {

    // TODO: Inject data source (network client, CoreData context, …)

    func fetchAll() async throws -> [Workout] {
        // TODO: Implement – call API or local DB
        return []
    }

    func save(_ workout: Workout) async throws {
        // TODO: Implement – persist workout
    }

    func delete(id: UUID) async throws {
        // TODO: Implement – remove workout by ID
    }
}
