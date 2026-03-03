// WorkoutView.swift
// EnduroTrack › Features › Workout › View
//
// VIPER: View layer for the Workout module.
// Renders workout state and forwards user events to the Presenter.

import SwiftUI
import Domain
import DesignSystem

/// The Workout screen — allows starting and managing a workout session.
struct WorkoutView: View {

    // MARK: - VIPER Wiring

    @StateObject private var presenter: WorkoutPresenter

    // MARK: - Init

    init(presenter: WorkoutPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Workout")
                .navigationBarTitleDisplayMode(.large)
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
            ProgressView("Starting workout…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .active(let workout):
            activeWorkoutView(workout: workout)
        case .finished(let workout):
            finishedWorkoutView(workout: workout)
        case .error(let message):
            errorView(message: message)
        }
    }

    // MARK: - Sub-Views

    private var idleView: some View {
        VStack(spacing: 24) {
            Text("Ready to train?")
                .font(AppFonts.displayMedium)
            Text("Set up your workout below.")
                .font(AppFonts.bodyLarge)
                .foregroundStyle(AppColors.textSecondary)

            PrimaryButton(title: "Start Workout") {
                presenter.didTapStartWorkout(title: "My Workout", type: .strength)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func activeWorkoutView(workout: Workout) -> some View {
        VStack(spacing: 16) {
            Text(workout.title)
                .font(AppFonts.displayMedium)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(workout.exercises) { exercise in
                        Card {
                            Text(exercise.name)
                                .font(AppFonts.headlineMedium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .onTapGesture {
                            presenter.didSelectExercise(exercise)
                        }
                    }
                }
                .padding(.horizontal)
            }

            PrimaryButton(title: "Finish Workout", style: .outlined) {
                presenter.didTapFinishWorkout()
            }
            .padding(.horizontal)
        }
    }

    private func finishedWorkoutView(workout: Workout) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(AppColors.success)
            Text("Workout Complete!")
                .font(AppFonts.displayMedium)
            StatBadge(label: "Duration", value: "\(workout.durationSeconds / 60) min", icon: "clock")
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
}
