// TimerView.swift
// EnduroTrack › Features › Timer › View
//
// VIPER: View layer for the Timer module.

import SwiftUI
import Domain
import DesignSystem

/// The Timer screen — displays interval timer presets and an active timer.
struct TimerView: View {

    // MARK: - VIPER Wiring

    @StateObject private var presenter: TimerPresenter

    // MARK: - Init

    init(presenter: TimerPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Timer")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            presenter.didTapCreateNewTimer()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
        .task {
            await presenter.viewDidAppear()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .loading:
            ProgressView("Loading presets…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .idle(let presets):
            presetsView(presets: presets)

        case .running(let session, let remaining, let index):
            activeTimerView(session: session, remainingSeconds: remaining, intervalIndex: index, isPaused: false)

        case .paused(let session, let remaining, let index):
            activeTimerView(session: session, remainingSeconds: remaining, intervalIndex: index, isPaused: true)

        case .finished(let session):
            finishedTimerView(session: session)

        case .error(let message):
            errorView(message: message)
        }
    }

    // MARK: - Sub-Views

    private func presetsView(presets: [TimerSession]) -> some View {
        Group {
            if presets.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "timer")
                        .font(.system(size: 64))
                        .foregroundStyle(AppColors.primary)
                    Text("No timer presets")
                        .font(AppFonts.headlineLarge)
                    Text("Tap + to create your first interval timer.")
                        .font(AppFonts.bodyMedium)
                        .foregroundStyle(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                    PrimaryButton(title: "Create Timer") {
                        presenter.didTapCreateNewTimer()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(presets) { preset in
                            Card {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(preset.name)
                                        .font(AppFonts.headlineMedium)
                                    Text("\(preset.intervals.count) intervals · ×\(preset.repeatCount)")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundStyle(AppColors.textSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .onTapGesture {
                                presenter.didTapStartTimer(session: preset)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private func activeTimerView(
        session: TimerSession,
        remainingSeconds: Int,
        intervalIndex: Int,
        isPaused: Bool
    ) -> some View {
        VStack(spacing: 32) {
            if intervalIndex < session.intervals.count {
                let interval = session.intervals[intervalIndex]
                Text(interval.label ?? interval.type.rawValue.capitalized)
                    .font(AppFonts.headlineLarge)
                    .foregroundStyle(AppColors.primary)
            }

            Text(formattedTime(remainingSeconds))
                .font(AppFonts.timerDisplay)
                .foregroundStyle(AppColors.textPrimary)
                .monospacedDigit()

            HStack(spacing: 16) {
                if isPaused {
                    PrimaryButton(title: "Resume") {
                        presenter.didTapResumeTimer()
                    }
                } else {
                    PrimaryButton(title: "Pause", style: .outlined) {
                        presenter.didTapPauseTimer()
                    }
                }
                PrimaryButton(title: "Stop", style: .outlined) {
                    presenter.didTapStopTimer()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func finishedTimerView(session: TimerSession) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(AppColors.success)
            Text("Timer Complete!")
                .font(AppFonts.displayMedium)
            Text(session.name)
                .font(AppFonts.bodyLarge)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.error)
            Text(message)
                .font(AppFonts.bodyLarge)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private func formattedTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
