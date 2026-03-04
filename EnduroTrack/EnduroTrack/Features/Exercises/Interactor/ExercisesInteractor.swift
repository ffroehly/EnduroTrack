// ExercisesInteractor.swift
// EnduroTrack › Features › Exercises

import Foundation
import Domain

final class ExercisesInteractor: ExercisesInteractorProtocol {

    private let fetchExercisesUseCase: FetchExercisesUseCaseProtocol
    private let createExerciseUseCase: CreateExerciseUseCaseProtocol
    private let updateExerciseUseCase: UpdateExerciseUseCaseProtocol
    private let deleteExerciseUseCase: DeleteExerciseUseCaseProtocol
    private let saveSessionUseCase: SaveExerciseSessionUseCaseProtocol

    init(
        fetchExercisesUseCase: FetchExercisesUseCaseProtocol,
        createExerciseUseCase: CreateExerciseUseCaseProtocol,
        updateExerciseUseCase: UpdateExerciseUseCaseProtocol,
        deleteExerciseUseCase: DeleteExerciseUseCaseProtocol,
        saveSessionUseCase: SaveExerciseSessionUseCaseProtocol
    ) {
        self.fetchExercisesUseCase = fetchExercisesUseCase
        self.createExerciseUseCase = createExerciseUseCase
        self.updateExerciseUseCase = updateExerciseUseCase
        self.deleteExerciseUseCase = deleteExerciseUseCase
        self.saveSessionUseCase = saveSessionUseCase
    }

    func fetchExercises() async throws -> [Exercise] {
        try await fetchExercisesUseCase.fetchAll()
    }

    func createExercise(title: String, warmupSeconds: Int, activeSeconds: Int, restSeconds: Int, repetitions: Int, recoverySeconds: Int?) async throws -> Exercise {
        let exercise = Exercise(
            title: title,
            warmupSeconds: warmupSeconds,
            activeSeconds: activeSeconds,
            restSeconds: restSeconds,
            repetitions: repetitions,
            recoverySeconds: recoverySeconds
        )
        return try await createExerciseUseCase.create(exercise: exercise)
    }

    func updateExercise(_ exercise: Exercise) async throws -> Exercise {
        try await updateExerciseUseCase.update(exercise: exercise)
    }

    func deleteExercise(id: UUID) async throws {
        try await deleteExerciseUseCase.delete(exerciseID: id)
    }

    func saveSession(_ session: ExerciseSession) async throws -> ExerciseSession {
        try await saveSessionUseCase.save(session: session)
    }
}
