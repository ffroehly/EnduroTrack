// EnduroTrackApp.swift
// EnduroTrack
//
// Application entry point and Composition Root.

import SwiftUI
import Domain

@main
struct EnduroTrackApp: App {

    // MARK: - Repositories

    private let exerciseRepository: ExerciseRepositoryProtocol = ExerciseRepository()
    private let scheduleRepository: ScheduleRepositoryProtocol = ScheduleRepository()
    private let sessionRepository: ExerciseSessionRepositoryProtocol = ExerciseSessionRepository()

    // MARK: - Services

    private var exerciseService: ExerciseService {
        ExerciseService(repository: exerciseRepository)
    }
    private var scheduleService: ScheduleService {
        ScheduleService(repository: scheduleRepository)
    }
    private var sessionService: ExerciseSessionService {
        ExerciseSessionService(repository: sessionRepository)
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            ContentView(
                fetchExercisesUseCase: exerciseService,
                createExerciseUseCase: exerciseService,
                updateExerciseUseCase: exerciseService,
                deleteExerciseUseCase: exerciseService,
                fetchSchedulesUseCase: scheduleService,
                createScheduleUseCase: scheduleService,
                updateScheduleUseCase: scheduleService,
                deleteScheduleUseCase: scheduleService,
                fetchSessionsUseCase: sessionService,
                saveSessionUseCase: sessionService
            )
        }
    }
}
