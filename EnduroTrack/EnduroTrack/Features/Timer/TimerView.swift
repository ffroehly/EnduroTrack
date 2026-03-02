//
//  TimerView.swift
//  EnduroTrack
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

/// Timer feature view – displays a stopwatch UI.
struct TimerView: View {
    @Bindable var store: StoreOf<TimerReducer>

    private var timeFormatted: String {
        let minutes = store.elapsedSeconds / 60
        let seconds = store.elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Text(timeFormatted)
                    .font(.system(size: 72, weight: .thin, design: .monospaced))

                HStack(spacing: 24) {
                    // TODO: Replace with PrimaryButton from DesignSystem
                    Button(store.isRunning ? "Stop" : "Start") {
                        store.send(store.isRunning ? .stopTapped : .startTapped)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        store.send(.resetTapped)
                    }
                    .buttonStyle(.bordered)
                    .disabled(store.isRunning)
                }
            }
            .navigationTitle("Timer")
        }
    }
}

#Preview {
    TimerView(store: Store(initialState: TimerReducer.State()) { TimerReducer() })
}
