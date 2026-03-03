// ContentView.swift
// EnduroTrack
//
// Root view of the application.

import SwiftUI
import Domain

struct ContentView: View {

    // MARK: - Use Case Dependencies

    let fetchExercisesUseCase: FetchExercisesUseCaseProtocol
    let createExerciseUseCase: CreateExerciseUseCaseProtocol
    let updateExerciseUseCase: UpdateExerciseUseCaseProtocol
    let deleteExerciseUseCase: DeleteExerciseUseCaseProtocol
    let fetchSchedulesUseCase: FetchSchedulesUseCaseProtocol
    let createScheduleUseCase: CreateScheduleUseCaseProtocol
    let updateScheduleUseCase: UpdateScheduleUseCaseProtocol
    let deleteScheduleUseCase: DeleteScheduleUseCaseProtocol
    let fetchSessionsUseCase: FetchExerciseSessionsUseCaseProtocol
    let saveSessionUseCase: SaveExerciseSessionUseCaseProtocol

    // MARK: - State

    @State private var selectedTab: AppTab = .home
    @AppStorage("colorScheme") private var colorSchemePreference: String = "system"

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
        .preferredColorScheme(preferredColorScheme)
    }

    private var preferredColorScheme: ColorScheme? {
        switch colorSchemePreference {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil
        }
    }

    @ViewBuilder
    private func tabView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeBuilder.build(
                fetchSchedulesUseCase: fetchSchedulesUseCase,
                fetchExercisesUseCase: fetchExercisesUseCase,
                fetchSessionsUseCase: fetchSessionsUseCase,
                onNavigateToSchedule: { selectedTab = .schedule },
                onNavigateToExercises: { selectedTab = .exercises }
            )

        case .exercises:
            ExercisesBuilder.build(
                fetchExercisesUseCase: fetchExercisesUseCase,
                createExerciseUseCase: createExerciseUseCase,
                updateExerciseUseCase: updateExerciseUseCase,
                deleteExerciseUseCase: deleteExerciseUseCase,
                saveSessionUseCase: saveSessionUseCase
            )

        case .schedule:
            ScheduleBuilder.build(
                fetchSchedulesUseCase: fetchSchedulesUseCase,
                createScheduleUseCase: createScheduleUseCase,
                updateScheduleUseCase: updateScheduleUseCase,
                deleteScheduleUseCase: deleteScheduleUseCase,
                fetchExercisesUseCase: fetchExercisesUseCase
            )

        case .history:
            HistoryBuilder.build(
                fetchSessionsUseCase: fetchSessionsUseCase
            )
        }
    }
}
