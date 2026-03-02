//
//  RunningRepository.swift
//  EnduroTrack
//

import Foundation
import Domain

/// Concrete implementation of RunningRepositoryProtocol.
/// Fetches and persists Run data.
struct RunningRepository: RunningRepositoryProtocol {

    // TODO: Inject data source

    func fetchAll() async throws -> [Run] {
        // TODO: Implement
        return []
    }

    func save(_ run: Run) async throws {
        // TODO: Implement
    }

    func delete(id: UUID) async throws {
        // TODO: Implement
    }
}
