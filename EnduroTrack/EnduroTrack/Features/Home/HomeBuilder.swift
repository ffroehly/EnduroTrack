// HomeBuilder.swift
// EnduroTrack › Features › Home

import SwiftUI
import Domain

enum HomeBuilder {

    @MainActor
    static func build(
        fetchSchedulesUseCase: FetchSchedulesUseCaseProtocol,
        fetchExercisesUseCase: FetchExercisesUseCaseProtocol,
        fetchSessionsUseCase: FetchExerciseSessionsUseCaseProtocol,
        onNavigateToSchedule: @escaping @MainActor () -> Void,
        onNavigateToExercises: @escaping @MainActor () -> Void
    ) -> some View {
        let router = HomeRouter(
            onNavigateToSchedule: onNavigateToSchedule,
            onNavigateToExercises: onNavigateToExercises
        )
        let interactor = HomeInteractor(
            fetchSchedulesUseCase: fetchSchedulesUseCase,
            fetchExercisesUseCase: fetchExercisesUseCase,
            fetchSessionsUseCase: fetchSessionsUseCase
        )
        let presenter = HomePresenter(interactor: interactor, router: router)
        return HomeView(presenter: presenter)
    }
}
