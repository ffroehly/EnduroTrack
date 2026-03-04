// ExercisesBuilder.swift
// EnduroTrack › Features › Exercises

import SwiftUI
import Domain

enum ExercisesBuilder {

    @MainActor
    static func build(
        fetchExercisesUseCase: FetchExercisesUseCaseProtocol,
        createExerciseUseCase: CreateExerciseUseCaseProtocol,
        updateExerciseUseCase: UpdateExerciseUseCaseProtocol,
        deleteExerciseUseCase: DeleteExerciseUseCaseProtocol,
        saveSessionUseCase: SaveExerciseSessionUseCaseProtocol
    ) -> some View {
        let router = ExercisesRouter()
        let interactor = ExercisesInteractor(
            fetchExercisesUseCase: fetchExercisesUseCase,
            createExerciseUseCase: createExerciseUseCase,
            updateExerciseUseCase: updateExerciseUseCase,
            deleteExerciseUseCase: deleteExerciseUseCase,
            saveSessionUseCase: saveSessionUseCase
        )
        let presenter = ExercisesPresenter(interactor: interactor, router: router)
        return ExercisesView(presenter: presenter)
    }
}
