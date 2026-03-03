// HomeInteractor.swift
// EnduroTrack › Features › Home › Interactor
//
// VIPER: Interactor layer.
// Responsibilities:
//  - Contains all business logic for the Home feature.
//  - Calls Use Cases (injected protocols) to fetch or mutate data.
//  - Returns Domain entities — never UI models.
//  - Has no knowledge of the View or Presenter.
//
// SOLID: Single Responsibility — one Interactor per feature.
// SOLID: Dependency Inversion — depends on use case protocols, not concrete types.

import Foundation
import Domain

/// Handles business logic for the Home feature.
final class HomeInteractor: HomeInteractorProtocol {

    // MARK: - Dependencies (injected use case protocols)

    private let fetchWorkoutsUseCase: FetchWorkoutsUseCaseProtocol

    // MARK: - Init

    init(fetchWorkoutsUseCase: FetchWorkoutsUseCaseProtocol) {
        self.fetchWorkoutsUseCase = fetchWorkoutsUseCase
    }

    // MARK: - HomeInteractorProtocol

    func fetchRecentWorkouts() async throws -> [Workout] {
        try await fetchWorkoutsUseCase.fetchAll()
    }
}
