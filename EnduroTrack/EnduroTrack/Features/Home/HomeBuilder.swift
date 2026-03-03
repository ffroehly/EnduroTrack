// HomeBuilder.swift
// EnduroTrack › Features › Home
//
// VIPER: Builder / Assembler.
// Responsibilities:
//  - Wire up all VIPER layers for the Home module.
//  - Inject dependencies into each layer.
//  - Return the assembled View ready to be presented.
//
// The Builder is the only place that knows about all layers simultaneously.
// This keeps construction logic out of all VIPER layers (SOLID: Single Responsibility).

import SwiftUI
import Domain

/// Assembles and returns a fully wired Home VIPER module.
enum HomeBuilder {

    /// Builds the Home module with the given use case dependencies.
    /// - Parameter fetchWorkoutsUseCase: The use case for fetching workouts.
    /// - Returns: A SwiftUI View representing the complete Home module.
    @MainActor
    static func build(
        fetchWorkoutsUseCase: FetchWorkoutsUseCaseProtocol
    ) -> some View {
        let router = HomeRouter()
        let interactor = HomeInteractor(fetchWorkoutsUseCase: fetchWorkoutsUseCase)
        let presenter = HomePresenter(interactor: interactor, router: router)
        return HomeView(presenter: presenter)
    }
}
