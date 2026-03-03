// HomeView.swift
// EnduroTrack › Features › Home › View
//
// VIPER: View layer.
// Responsibilities:
//  - Render UI based on state provided by the Presenter.
//  - Forward user interactions to the Presenter.
//  - No business logic — only layout and display.
//
// The View observes the Presenter (an ObservableObject) for state changes.

import SwiftUI
import Domain
import DesignSystem

/// The Home screen — displays a summary of recent workouts.
struct HomeView: View {

    // MARK: - VIPER Wiring

    /// The Presenter drives all state. The View only calls back on user actions.
    @StateObject private var presenter: HomePresenter

    // MARK: - Init

    init(presenter: HomePresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("EnduroTrack")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            presenter.didTapNewWorkout()
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
            loadingView
        case .loaded(let workouts):
            workoutListView(workouts: workouts)
        case .error(let message):
            errorView(message: message)
        case .empty:
            emptyView
        }
    }

    // MARK: - Sub-Views

    private var loadingView: some View {
        ProgressView("Loading workouts…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func workoutListView(workouts: [Workout]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(workouts) { workout in
                    Card {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(workout.title)
                                .font(AppFonts.headlineMedium)
                            Text(workout.type.displayName)
                                .font(AppFonts.bodyMedium)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .onTapGesture {
                        presenter.didSelectWorkout(workout)
                    }
                }
            }
            .padding()
        }
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.primary)
            Text("No workouts yet")
                .font(AppFonts.headlineLarge)
            Text("Tap + to create your first workout.")
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            PrimaryButton(title: "New Workout") {
                presenter.didTapNewWorkout()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.error)
            Text("Something went wrong")
                .font(AppFonts.headlineLarge)
            Text(message)
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
