//
//  RunningView.swift
//  EnduroTrack
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

/// Running feature view – shows run history and start button.
struct RunningView: View {
    @Bindable var store: StoreOf<RunningReducer>

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView()
                } else if store.runs.isEmpty {
                    ContentUnavailableView(
                        "No Runs",
                        systemImage: "figure.run",
                        description: Text("Start your first run to track your progress.")
                    )
                } else {
                    List(store.runs) { run in
                        // TODO: Replace with RunCard from DesignSystem
                        Text(run.name)
                    }
                }
            }
            .navigationTitle("Running")
            .onAppear { store.send(.onAppear) }
        }
    }
}

#Preview {
    RunningView(store: Store(initialState: RunningReducer.State()) { RunningReducer() })
}
