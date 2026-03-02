//
//  TimerReducer.swift
//  EnduroTrack
//

import ComposableArchitecture

/// Timer feature reducer.
/// Controls a stopwatch / interval timer for training sessions.
@Reducer
struct TimerReducer {

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var elapsedSeconds: Int = 0
        var isRunning: Bool = false
        // TODO: Add interval configuration, laps …
    }

    // MARK: - Action
    enum Action {
        case startTapped
        case stopTapped
        case resetTapped
        case timerTicked
        // TODO: Add lap, interval actions
    }

    // MARK: - Reducer body
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTapped:
                state.isRunning = true
                // TODO: Start a repeating Effect.timer
                return .none

            case .stopTapped:
                state.isRunning = false
                // TODO: Cancel the timer effect
                return .none

            case .resetTapped:
                state.isRunning = false
                state.elapsedSeconds = 0
                return .none

            case .timerTicked:
                state.elapsedSeconds += 1
                return .none
            }
        }
    }
}
