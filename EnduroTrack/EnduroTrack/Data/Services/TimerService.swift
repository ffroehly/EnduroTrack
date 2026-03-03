// TimerService.swift
// EnduroTrack › Data › Services
//
// Service layer implementing timer use cases using TimerSessionRepositoryProtocol.

import Foundation
import Domain

/// Implements timer session use cases by delegating to TimerSessionRepositoryProtocol.
final class TimerService:
    FetchTimerSessionsUseCaseProtocol,
    CreateTimerSessionUseCaseProtocol,
    DeleteTimerSessionUseCaseProtocol {

    // MARK: - Dependencies

    private let repository: TimerSessionRepositoryProtocol

    // MARK: - Init

    init(repository: TimerSessionRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - FetchTimerSessionsUseCaseProtocol

    func execute() async throws -> [TimerSession] {
        try await repository.fetchAll()
    }

    // MARK: - CreateTimerSessionUseCaseProtocol

    func execute(session: TimerSession) async throws -> TimerSession {
        try await repository.save(session)
    }

    // MARK: - DeleteTimerSessionUseCaseProtocol

    func execute(sessionID: UUID) async throws {
        try await repository.delete(id: sessionID)
    }
}
