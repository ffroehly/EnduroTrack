// HomeRouter.swift
// EnduroTrack › Features › Home › Router
//
// VIPER: Router layer.
// Responsibilities:
//  - Handles all navigation decisions for the Home module.
//  - Builds destination VIPER modules via their Builders.
//  - The Presenter calls the Router; the Router wires up new modules.
//
// In SwiftUI, navigation is driven by a NavigationPath or sheet bindings.
// The Router owns a NavigationPath published to the View.

import SwiftUI
import Domain
import Combine

/// Drives navigation from the Home screen.
@MainActor
final class HomeRouter: HomeRouterProtocol, ObservableObject {

    // MARK: - Navigation State

    /// Bindable navigation path used by the NavigationStack in HomeView.
    @Published var navigationPath = NavigationPath()

    /// Destination driven by sheet presentation.
    @Published var sheetDestination: HomeSheetDestination?

    // MARK: - HomeRouterProtocol

    func navigateToWorkoutDetail(workout: Workout) {
        navigationPath.append(HomeDestination.workoutDetail(workout))
    }

    func navigateToNewWorkout() {
        sheetDestination = .newWorkout
    }
}

// MARK: - Destination Types

/// Push-navigation destinations from Home.
enum HomeDestination: Hashable {
    case workoutDetail(Workout)
}

/// Sheet/modal destinations from Home.
enum HomeSheetDestination: Identifiable {
    case newWorkout

    var id: String {
        switch self {
        case .newWorkout: return "newWorkout"
        }
    }
}
