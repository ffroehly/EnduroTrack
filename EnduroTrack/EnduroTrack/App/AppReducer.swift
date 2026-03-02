//
//  AppReducer.swift
//  EnduroTrack
//

import ComposableArchitecture

/// Root reducer that composes all feature reducers.
/// Follows TCA pattern: a single store for the whole app, scoped per feature.
@Reducer
struct AppReducer {
    @ObservableState
    struct State: Equatable {
        var home: HomeReducer.State = .init()
        var workout: WorkoutReducer.State = .init()
        var running: RunningReducer.State = .init()
        var timer: TimerReducer.State = .init()
    }

    enum Action {
        case home(HomeReducer.Action)
        case workout(WorkoutReducer.Action)
        case running(RunningReducer.Action)
        case timer(TimerReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) { HomeReducer() }
        Scope(state: \.workout, action: \.workout) { WorkoutReducer() }
        Scope(state: \.running, action: \.running) { RunningReducer() }
        Scope(state: \.timer, action: \.timer) { TimerReducer() }
    }
}
