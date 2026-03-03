// RunningView.swift
// EnduroTrack › Features › Running › View
//
// VIPER: View layer for the Running module.

import SwiftUI
import Domain
import DesignSystem

/// The Running screen — allows starting and tracking a run session.
struct RunningView: View {

    // MARK: - VIPER Wiring

    @StateObject private var presenter: RunningPresenter

    // MARK: - Init

    init(presenter: RunningPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Running")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("History") {
                            presenter.didTapHistory()
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
        case .idle:
            idleView
        case .loading:
            ProgressView("Preparing…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .running(let session):
            runningView(session: session)
        case .stopped(let session):
            stoppedView(session: session)
        case .error(let message):
            errorView(message: message)
        }
    }

    // MARK: - Sub-Views

    private var idleView: some View {
        VStack(spacing: 32) {
            Image(systemName: "figure.run")
                .font(.system(size: 80))
                .foregroundStyle(AppColors.runningAccent)
            Text("Ready to run?")
                .font(AppFonts.displayMedium)
            PrimaryButton(title: "Start Run") {
                presenter.didTapStartRun()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func runningView(session: RunSession) -> some View {
        VStack(spacing: 24) {
            Text("Running…")
                .font(AppFonts.displayMedium)
                .foregroundStyle(AppColors.runningAccent)

            HStack(spacing: 32) {
                StatBadge(
                    label: "Distance",
                    value: String(format: "%.2f km", session.distanceMeters / 1000),
                    icon: "figure.run"
                )
                StatBadge(
                    label: "Duration",
                    value: formattedDuration(session.durationSeconds),
                    icon: "clock"
                )
            }

            PrimaryButton(title: "Stop", style: .outlined) {
                presenter.didTapStopRun()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func stoppedView(session: RunSession) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "flag.checkered.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(AppColors.success)
            Text("Run Complete!")
                .font(AppFonts.displayMedium)
            HStack(spacing: 32) {
                StatBadge(
                    label: "Distance",
                    value: String(format: "%.2f km", session.distanceMeters / 1000),
                    icon: "figure.run"
                )
                StatBadge(
                    label: "Duration",
                    value: formattedDuration(session.durationSeconds),
                    icon: "clock"
                )
            }
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

    private func formattedDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
