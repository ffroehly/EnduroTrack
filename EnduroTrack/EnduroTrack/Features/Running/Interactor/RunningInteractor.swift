// RunningInteractor.swift
// EnduroTrack › Features › Running › Interactor
//
// VIPER: Interactor layer for the Running module.
// Contains business logic for starting, tracking, and stopping runs.

import Foundation
import Domain

/// Handles business logic for the Running feature.
final class RunningInteractor: RunningInteractorProtocol {

    // MARK: - Dependencies

    private let saveRunSessionUseCase: SaveRunSessionUseCaseProtocol
    private let fetchRunSessionsUseCase: FetchRunSessionsUseCaseProtocol

    // MARK: - Init

    init(
        saveRunSessionUseCase: SaveRunSessionUseCaseProtocol,
        fetchRunSessionsUseCase: FetchRunSessionsUseCaseProtocol
    ) {
        self.saveRunSessionUseCase = saveRunSessionUseCase
        self.fetchRunSessionsUseCase = fetchRunSessionsUseCase
    }

    // MARK: - RunningInteractorProtocol

    func startRun() async throws -> RunSession {
        let session = RunSession(
            startedAt: Date(),
            distanceMeters: 0,
            durationSeconds: 0
        )
        return try await saveRunSessionUseCase.save(session: session)
    }

    func stopRun(_ session: RunSession) async throws -> RunSession {
        let stopped = RunSession(
            id: session.id,
            startedAt: session.startedAt,
            finishedAt: Date(),
            distanceMeters: session.distanceMeters,
            durationSeconds: Int(Date().timeIntervalSince(session.startedAt)),
            averagePaceSecondsPerKm: session.averagePaceSecondsPerKm,
            calories: session.calories,
            route: session.route
        )
        return try await saveRunSessionUseCase.save(session: stopped)
    }

    func fetchRunHistory() async throws -> [RunSession] {
        try await fetchRunSessionsUseCase.fetchAll()
    }
}
