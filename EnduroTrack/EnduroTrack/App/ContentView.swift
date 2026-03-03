// ContentView.swift
// EnduroTrack › App
//
// Root view of the application.
// Provides a tab-based navigation structure across all features.
// Each tab assembles its VIPER module via its Builder.

import SwiftUI
import Domain

/// The root view. Hosts the main tab bar and wires up feature modules.
struct ContentView: View {

    // MARK: - Use Case Dependencies (injected from App entry point)

    let fetchWorkoutsUseCase: FetchWorkoutsUseCaseProtocol
    let createWorkoutUseCase: CreateWorkoutUseCaseProtocol
    let updateWorkoutUseCase: UpdateWorkoutUseCaseProtocol
    let saveRunSessionUseCase: SaveRunSessionUseCaseProtocol
    let fetchRunSessionsUseCase: FetchRunSessionsUseCaseProtocol
    let fetchTimerSessionsUseCase: FetchTimerSessionsUseCaseProtocol

    // MARK: - State

    @State private var selectedTab: AppTab = .home

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
    }

    // MARK: - Tab Builder

    @ViewBuilder
    private func tabView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeBuilder.build(fetchWorkoutsUseCase: fetchWorkoutsUseCase)

        case .workout:
            WorkoutBuilder.build(
                createWorkoutUseCase: createWorkoutUseCase,
                updateWorkoutUseCase: updateWorkoutUseCase
            )

        case .running:
            RunningBuilder.build(
                saveRunSessionUseCase: saveRunSessionUseCase,
                fetchRunSessionsUseCase: fetchRunSessionsUseCase
            )

        case .timer:
            TimerBuilder.build(fetchTimerSessionsUseCase: fetchTimerSessionsUseCase)
        }
    }
}
