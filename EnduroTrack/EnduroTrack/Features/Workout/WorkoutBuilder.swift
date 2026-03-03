// WorkoutBuilder.swift
// EnduroTrack › Features › Workout
//
// VIPER Builder — assembles the Workout module with injected dependencies.

import SwiftUI
import Domain

/// Assembles and returns a fully wired Workout VIPER module.
enum WorkoutBuilder {

    @MainActor
    static func build(
        createWorkoutUseCase: CreateWorkoutUseCaseProtocol,
        updateWorkoutUseCase: UpdateWorkoutUseCaseProtocol
    ) -> some View {
        let router = WorkoutRouter()
        let interactor = WorkoutInteractor(
            createWorkoutUseCase: createWorkoutUseCase,
            updateWorkoutUseCase: updateWorkoutUseCase
        )
        let presenter = WorkoutPresenter(interactor: interactor, router: router)
        return WorkoutView(presenter: presenter)
    }
}
