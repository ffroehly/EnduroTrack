// HistoryInteractor.swift
// EnduroTrack › Features › History

import Foundation
import Domain

final class HistoryInteractor: HistoryInteractorProtocol {

    private let fetchSessionsUseCase: FetchExerciseSessionsUseCaseProtocol

    init(fetchSessionsUseCase: FetchExerciseSessionsUseCaseProtocol) {
        self.fetchSessionsUseCase = fetchSessionsUseCase
    }

    func fetchAllSessions() async throws -> [ExerciseSession] {
        try await fetchSessionsUseCase.fetchAll()
    }
}
