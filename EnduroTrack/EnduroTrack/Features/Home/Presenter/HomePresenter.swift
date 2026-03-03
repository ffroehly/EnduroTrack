// HomePresenter.swift
// EnduroTrack › Features › Home › Presenter
//
// VIPER: Presenter layer.
// Responsibilities:
//  - Receive user events from the View.
//  - Call the Interactor to perform business operations.
//  - Transform Interactor results into View state.
//  - Call the Router for navigation.
//  - Never import UIKit/SwiftUI (only Foundation + Domain).
//
// The Presenter is an ObservableObject so SwiftUI Views can observe its @Published state.
// This is the recommended SwiftUI-compatible VIPER pattern (replaces the classic weak-ref View delegate).

import Foundation
import Domain

/// Drives the Home screen. Observed by HomeView.
@MainActor
final class HomePresenter: ObservableObject, HomePresenterProtocol {

    // MARK: - Published State

    /// The current view state. HomeView re-renders whenever this changes.
    @Published private(set) var state: HomeViewState = .loading

    // MARK: - VIPER Dependencies

    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol

    // MARK: - Init

    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - HomePresenterProtocol

    func viewDidAppear() async {
        state = .loading
        do {
            let workouts = try await interactor.fetchRecentWorkouts()
            state = workouts.isEmpty ? .empty : .loaded(workouts: workouts)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    func didSelectWorkout(_ workout: Workout) {
        router.navigateToWorkoutDetail(workout: workout)
    }

    func didTapNewWorkout() {
        router.navigateToNewWorkout()
    }
}
