//
//  WorkoutReducer.swift
//  EnduroTrack
//

import ComposableArchitecture
import Domain

/// Workout feature reducer.
/// Manages the list and detail of workouts.
@Reducer
struct WorkoutReducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var workouts: [Workout] = []
        var isLoading: Bool = false
        // TODO: Add more state (selected workout, error message …)
    }

    // MARK: - Action
    enum Action {
        case onAppear
        case workoutsLoaded([Workout])
        // TODO: Add actions (create, delete, selectWorkout …)
    }

    // MARK: - Dependencies
    // @Dependency(\.workoutRepository) var workoutRepository

    // MARK: - Reducer body
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                // TODO: Load workouts via use case / repository
                return .none

            case let .workoutsLoaded(workouts):
                state.isLoading = false
                state.workouts = workouts
                return .none
            }
        }
    }
}
