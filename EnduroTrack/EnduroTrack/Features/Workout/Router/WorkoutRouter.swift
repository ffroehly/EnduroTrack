// WorkoutRouter.swift
// EnduroTrack › Features › Workout › Router
//
// VIPER: Router layer for the Workout module.
// Handles all navigation originating from the Workout screen.

import SwiftUI
import Domain
import Combine

/// Drives navigation from the Workout screen.
@MainActor
final class WorkoutRouter: WorkoutRouterProtocol, ObservableObject {

    // MARK: - Navigation State

    @Published var navigationPath = NavigationPath()
    @Published var sheetDestination: WorkoutSheetDestination?

    // MARK: - WorkoutRouterProtocol

    func navigateToExerciseDetail(_ exercise: Exercise) {
        navigationPath.append(WorkoutDestination.exerciseDetail(exercise))
    }

    func dismissWorkout() {
        navigationPath = NavigationPath()
    }
}

// MARK: - Destination Types

enum WorkoutDestination: Hashable {
    case exerciseDetail(Exercise)
}

enum WorkoutSheetDestination: Identifiable {
    case addExercise

    var id: String {
        switch self {
        case .addExercise: return "addExercise"
        }
    }
}
