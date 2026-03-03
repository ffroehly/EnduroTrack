// HomeContracts.swift
// EnduroTrack › Features › Home
//
// VIPER contracts for the Home module.
// All VIPER layer interactions are defined here as protocols, enabling:
//  - Testability (mock any layer)
//  - Replaceability (swap implementations without touching other layers)
//  - Clear boundaries between layers (SOLID: Interface Segregation)
//
// ┌─────────┐  notifies  ┌───────────┐  requests  ┌────────────┐
// │  View   │ ─────────► │ Presenter │ ──────────► │ Interactor │
// └─────────┘            └───────────┘             └────────────┘
//      ▲                       │
//      └─── updates ───────────┘
//                              │ navigates
//                              ▼
//                         ┌────────┐
//                         │ Router │
//                         └────────┘

import Foundation
import Domain

// MARK: - View Protocol

/// What the Presenter can call on the View.
/// The View only renders state — it never fetches data.
@MainActor
protocol HomeViewProtocol: AnyObject {
    /// Called when the Presenter has new state to display.
    func render(state: HomeViewState)
}

// MARK: - Presenter Protocol

/// What the View can call on the Presenter.
/// The Presenter orchestrates Interactor calls and View updates.
@MainActor
protocol HomePresenterProtocol: AnyObject {
    /// Called when the view appears.
    func viewDidAppear() async

    /// Called when the user taps a workout card.
    func didSelectWorkout(_ workout: Workout)

    /// Called when the user taps the "New Workout" button.
    func didTapNewWorkout()
}

// MARK: - Interactor Protocol

/// What the Presenter can call on the Interactor.
/// The Interactor contains only business logic and data access.
protocol HomeInteractorProtocol: AnyObject {
    /// Fetches the list of recent workouts.
    func fetchRecentWorkouts() async throws -> [Workout]
}

// MARK: - Router Protocol

/// What the Presenter can call on the Router.
/// The Router handles all navigation/coordination decisions.
@MainActor
protocol HomeRouterProtocol: AnyObject {
    /// Navigates to the Workout detail screen.
    func navigateToWorkoutDetail(workout: Workout)

    /// Navigates to the New Workout creation screen.
    func navigateToNewWorkout()
}

// MARK: - View State

/// All possible states the Home screen can be in.
/// Using an enum ensures the View only ever renders one well-defined state.
enum HomeViewState: Equatable {
    /// Initial loading state.
    case loading

    /// Successfully loaded with a list of recent workouts.
    case loaded(workouts: [Workout])

    /// An error occurred while loading.
    case error(message: String)

    /// No workouts exist yet.
    case empty
}
