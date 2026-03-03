// RunningBuilder.swift
// EnduroTrack › Features › Running
//
// VIPER Builder — assembles the Running module with injected dependencies.

import SwiftUI
import Domain

/// Assembles and returns a fully wired Running VIPER module.
enum RunningBuilder {

    @MainActor
    static func build(
        saveRunSessionUseCase: SaveRunSessionUseCaseProtocol,
        fetchRunSessionsUseCase: FetchRunSessionsUseCaseProtocol
    ) -> some View {
        let router = RunningRouter()
        let interactor = RunningInteractor(
            saveRunSessionUseCase: saveRunSessionUseCase,
            fetchRunSessionsUseCase: fetchRunSessionsUseCase
        )
        let presenter = RunningPresenter(interactor: interactor, router: router)
        return RunningView(presenter: presenter)
    }
}
