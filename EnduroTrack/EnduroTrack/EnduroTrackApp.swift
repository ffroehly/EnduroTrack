//
//  EnduroTrackApp.swift
//  EnduroTrack
//
//  Created by Fabrice FROEHLY on 02/03/2026.
//
// Application entry point and Composition Root.
// Responsibilities:
//  - Bootstrap the dependency graph (repositories, services, use cases).
//  - Provide the root window via ContentView.
//
// This is the only file that instantiates concrete types.
// All feature modules receive protocol abstractions, never concrete types directly.

import SwiftUI
import Domain

@main
struct EnduroTrackApp: App {

    // MARK: - Dependency Graph (Composition Root)

    // Repositories
    private let workoutRepository: WorkoutRepositoryProtocol = WorkoutRepository()
    private let runSessionRepository: RunSessionRepositoryProtocol = RunSessionRepository()
    private let timerSessionRepository: TimerSessionRepositoryProtocol = TimerSessionRepository()

    // Services (Use Case implementations)
    private var workoutService: WorkoutService {
        WorkoutService(repository: workoutRepository)
    }
    private var runningService: RunningService {
        RunningService(repository: runSessionRepository)
    }
    private var timerService: TimerService {
        TimerService(repository: timerSessionRepository)
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            ContentView(
                fetchWorkoutsUseCase: workoutService,
                createWorkoutUseCase: workoutService,
                updateWorkoutUseCase: workoutService,
                saveRunSessionUseCase: runningService,
                fetchRunSessionsUseCase: runningService,
                fetchTimerSessionsUseCase: timerService
            )
        }
    }
}

