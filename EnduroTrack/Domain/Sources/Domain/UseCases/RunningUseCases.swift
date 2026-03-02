//
//  RunningUseCases.swift
//  Domain
//

import Foundation

// MARK: - Repository Protocol

/// Contract that any Run data source must fulfil.
public protocol RunningRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [Run]
    func save(_ run: Run) async throws
    func delete(id: UUID) async throws
}

// MARK: - Use Cases

/// Fetches all past runs.
public struct FetchRunsUseCase: Sendable {
    private let repository: any RunningRepositoryProtocol

    public init(repository: any RunningRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Run] {
        try await repository.fetchAll()
    }
}

/// Saves a completed run after validation.
public struct SaveRunUseCase: Sendable {
    private let repository: any RunningRepositoryProtocol

    public init(repository: any RunningRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(_ run: Run) async throws {
        guard run.distance.metres > 0 else {
            throw RunError.invalidDistance
        }
        try await repository.save(run)
    }
}

// MARK: - Domain Errors

public enum RunError: Error, Equatable {
    case invalidDistance
    case notFound(UUID)
    case saveFailed
}
