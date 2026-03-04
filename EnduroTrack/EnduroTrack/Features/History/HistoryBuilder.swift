// HistoryBuilder.swift
// EnduroTrack › Features › History

import SwiftUI
import Domain

enum HistoryBuilder {

    @MainActor
    static func build(
        fetchSessionsUseCase: FetchExerciseSessionsUseCaseProtocol
    ) -> some View {
        let router = HistoryRouter()
        let interactor = HistoryInteractor(fetchSessionsUseCase: fetchSessionsUseCase)
        let presenter = HistoryPresenter(interactor: interactor, router: router)
        return HistoryView(presenter: presenter)
    }
}
