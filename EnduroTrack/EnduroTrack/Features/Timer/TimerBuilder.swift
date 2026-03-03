// TimerBuilder.swift
// EnduroTrack › Features › Timer
//
// VIPER Builder — assembles the Timer module with injected dependencies.

import SwiftUI
import Domain

/// Assembles and returns a fully wired Timer VIPER module.
enum TimerBuilder {

    @MainActor
    static func build(
        fetchTimerSessionsUseCase: FetchTimerSessionsUseCaseProtocol
    ) -> some View {
        let router = TimerRouter()
        let interactor = TimerInteractor(fetchTimerSessionsUseCase: fetchTimerSessionsUseCase)
        let presenter = TimerPresenter(interactor: interactor, router: router)
        return TimerView(presenter: presenter)
    }
}
