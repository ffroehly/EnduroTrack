// TimerInteractor.swift
// EnduroTrack › Features › Timer › Interactor
//
// VIPER: Interactor layer for the Timer module.

import Foundation
import Domain

/// Handles business logic for the Timer feature.
final class TimerInteractor: TimerInteractorProtocol {

    // MARK: - Dependencies

    private let fetchTimerSessionsUseCase: FetchTimerSessionsUseCaseProtocol

    // MARK: - Init

    init(fetchTimerSessionsUseCase: FetchTimerSessionsUseCaseProtocol) {
        self.fetchTimerSessionsUseCase = fetchTimerSessionsUseCase
    }

    // MARK: - TimerInteractorProtocol

    func fetchTimerPresets() async throws -> [TimerSession] {
        try await fetchTimerSessionsUseCase.execute()
    }
}
