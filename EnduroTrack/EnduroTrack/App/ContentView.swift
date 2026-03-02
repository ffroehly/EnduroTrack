//
//  ContentView.swift
//  EnduroTrack
//
//  Created by Fabrice FROEHLY on 02/03/2026.
//

import SwiftUI
import ComposableArchitecture

/// Root view of the application.
/// Uses a TCA store scoped to each feature tab.
struct ContentView: View {
    @Bindable var store: StoreOf<AppReducer>

    var body: some View {
        TabView {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            WorkoutView(store: store.scope(state: \.workout, action: \.workout))
                .tabItem {
                    Label("Workout", systemImage: "dumbbell.fill")
                }

            RunningView(store: store.scope(state: \.running, action: \.running))
                .tabItem {
                    Label("Running", systemImage: "figure.run")
                }

            TimerView(store: store.scope(state: \.timer, action: \.timer))
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: AppReducer.State()) {
            AppReducer()
        }
    )
}
