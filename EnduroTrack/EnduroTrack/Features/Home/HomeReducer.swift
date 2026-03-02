//
//  HomeReducer.swift
//  EnduroTrack
//

import ComposableArchitecture
import Domain

/// Home feature reducer.
/// Responsible for displaying the dashboard / summary view.
@Reducer
struct HomeReducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        // TODO: Add state properties (e.g. recent workouts, user stats)
    }

    // MARK: - Action
    enum Action {
        case onAppear
        // TODO: Add feature-specific actions
    }

    // MARK: - Dependencies
    // @Dependency(\.workoutRepository) var workoutRepository

    // MARK: - Reducer body
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // TODO: Load initial data
                return .none
            }
        }
    }
}
