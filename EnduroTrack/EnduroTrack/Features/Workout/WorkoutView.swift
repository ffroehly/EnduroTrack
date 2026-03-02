//
//  WorkoutView.swift
//  EnduroTrack
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

/// Workout feature view – lists all workouts.
struct WorkoutView: View {
    @Bindable var store: StoreOf<WorkoutReducer>

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView()
                } else if store.workouts.isEmpty {
                    ContentUnavailableView(
                        "No Workouts",
                        systemImage: "dumbbell",
                        description: Text("Add your first workout to get started.")
                    )
                } else {
                    List(store.workouts) { workout in
                        // TODO: Replace with WorkoutCard from DesignSystem
                        Text(workout.name)
                    }
                }
            }
            .navigationTitle("Workouts")
            .onAppear { store.send(.onAppear) }
        }
    }
}

#Preview {
    WorkoutView(store: Store(initialState: WorkoutReducer.State()) { WorkoutReducer() })
}
