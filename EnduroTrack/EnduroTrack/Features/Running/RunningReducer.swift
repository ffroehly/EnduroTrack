//
//  RunningReducer.swift
//  EnduroTrack
//

import ComposableArchitecture
import Domain

/// Running feature reducer.
/// Manages running sessions (history and active tracking).
@Reducer
struct RunningReducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var runs: [Run] = []
        var isLoading: Bool = false
        // TODO: Add state for active run, GPS data …
    }

    // MARK: - Action
    enum Action {
        case onAppear
        case runsLoaded([Run])
        // TODO: startRun, stopRun, updateLocation …
    }

    // MARK: - Dependencies
    // @Dependency(\.runningRepository) var runningRepository

    // MARK: - Reducer body
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                // TODO: Fetch past runs via use case
                return .none

            case let .runsLoaded(runs):
                state.isLoading = false
                state.runs = runs
                return .none
            }
        }
    }
}
