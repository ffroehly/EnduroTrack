// RunningBuilder.swift (Schedule feature)
// EnduroTrack › Features › Running (Schedule)

import SwiftUI
import Domain

enum ScheduleBuilder {

    @MainActor
    static func build(
        fetchSchedulesUseCase: FetchSchedulesUseCaseProtocol,
        createScheduleUseCase: CreateScheduleUseCaseProtocol,
        updateScheduleUseCase: UpdateScheduleUseCaseProtocol,
        deleteScheduleUseCase: DeleteScheduleUseCaseProtocol,
        fetchExercisesUseCase: FetchExercisesUseCaseProtocol
    ) -> some View {
        let router = ScheduleRouter()
        let interactor = ScheduleInteractor(
            fetchSchedulesUseCase: fetchSchedulesUseCase,
            createScheduleUseCase: createScheduleUseCase,
            updateScheduleUseCase: updateScheduleUseCase,
            deleteScheduleUseCase: deleteScheduleUseCase,
            fetchExercisesUseCase: fetchExercisesUseCase
        )
        let presenter = SchedulePresenter(interactor: interactor, router: router)
        return ScheduleView(presenter: presenter)
    }
}
