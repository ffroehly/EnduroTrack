// HomeRouter.swift
// EnduroTrack › Features › Home

import SwiftUI
import Domain

@MainActor
final class HomeRouter: HomeRouterProtocol, ObservableObject {

    private let onNavigateToScheduleCallback: @MainActor () -> Void
    private let onNavigateToExercisesCallback: @MainActor () -> Void

    init(
        onNavigateToSchedule: @escaping @MainActor () -> Void,
        onNavigateToExercises: @escaping @MainActor () -> Void
    ) {
        self.onNavigateToScheduleCallback = onNavigateToSchedule
        self.onNavigateToExercisesCallback = onNavigateToExercises
    }

    func navigateToSchedule() {
        onNavigateToScheduleCallback()
    }

    func navigateToExercises() {
        onNavigateToExercisesCallback()
    }
}
