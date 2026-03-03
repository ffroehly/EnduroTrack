// RunningService.swift
// EnduroTrack › Data › Services
//
// Service layer implementing running use cases using RunSessionRepositoryProtocol.

import Foundation
import Domain

/// Implements run session use cases by delegating to RunSessionRepositoryProtocol.
final class RunningService:
    FetchRunSessionsUseCaseProtocol,
    SaveRunSessionUseCaseProtocol,
    DeleteRunSessionUseCaseProtocol {

    // MARK: - Dependencies

    private let repository: RunSessionRepositoryProtocol

    // MARK: - Init

    init(repository: RunSessionRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - FetchRunSessionsUseCaseProtocol

    func execute() async throws -> [RunSession] {
        try await repository.fetchAll()
    }

    // MARK: - SaveRunSessionUseCaseProtocol

    func execute(session: RunSession) async throws -> RunSession {
        try await repository.save(session)
    }

    // MARK: - DeleteRunSessionUseCaseProtocol

    func execute(sessionID: UUID) async throws {
        try await repository.delete(id: sessionID)
    }
}
