//
//  HomeView.swift
//  EnduroTrack
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

/// Home feature view – displays the main dashboard.
struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.tint)

                Text("Welcome to EnduroTrack")
                    .font(.title2)
                    .bold()

                Text("Your training dashboard")
                    .foregroundStyle(.secondary)

                // TODO: Replace with real content using DesignSystem components
                // e.g. WorkoutCard, StatsCard …
            }
            .padding()
            .navigationTitle("Home")
            .onAppear { store.send(.onAppear) }
        }
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeReducer.State()) { HomeReducer() })
}
