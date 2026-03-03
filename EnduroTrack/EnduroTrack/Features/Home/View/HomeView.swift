// HomeView.swift
// EnduroTrack › Features › Home

import SwiftUI
import Charts
import Domain
import DesignSystem

struct HomeView: View {

    @StateObject private var presenter: HomePresenter
    @AppStorage("colorScheme") private var colorSchemePreference: String = "system"
    @State private var showingSettings = false

    init(presenter: HomePresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("EnduroTrack")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView(colorSchemePreference: $colorSchemePreference)
                }
        }
        .task {
            await presenter.viewDidAppear()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .loading:
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let nextExercise, let recentSessions):
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    nextExerciseSection(nextExercise)
                    if !recentSessions.isEmpty {
                        recentSessionsChart(recentSessions)
                    }
                }
                .padding()
            }

        case .error(let message):
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 48))
                    .foregroundStyle(AppColors.error)
                Text(message)
                    .font(AppFonts.bodyMedium)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Next Exercise Section

    @ViewBuilder
    private func nextExerciseSection(_ info: NextExerciseInfo?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Next Exercise")
                .font(AppFonts.headlineLarge)

            if let info {
                Card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(info.exerciseTitle)
                            .font(AppFonts.headlineMedium)
                            .foregroundStyle(AppColors.textPrimary)
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(AppColors.textSecondary)
                            Text(info.isToday ? "Today at \(info.reminderTimeFormatted)" : "\(info.dayOfWeek.displayName) at \(info.reminderTimeFormatted)")
                                .font(AppFonts.bodyMedium)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        if info.isToday {
                            PrimaryButton(title: "Start Now") {
                                presenter.didTapStartExercise(exerciseId: info.exerciseId)
                            }
                        }
                    }
                }
            } else {
                Card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("No exercise scheduled")
                            .font(AppFonts.headlineMedium)
                            .foregroundStyle(AppColors.textSecondary)
                        PrimaryButton(title: "Set Up Schedule", style: .outlined) {
                            presenter.didTapGoToSchedule()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Recent Sessions Chart

    private func recentSessionsChart(_ sessions: [ExerciseSession]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(AppFonts.headlineLarge)

            Card {
                Chart(Array(sessions.prefix(5).reversed())) { session in
                    LineMark(
                        x: .value("Date", session.completedAt),
                        y: .value("Duration (min)", session.durationSeconds / 60)
                    )
                    .foregroundStyle(AppColors.primary)
                    PointMark(
                        x: .value("Date", session.completedAt),
                        y: .value("Duration (min)", session.durationSeconds / 60)
                    )
                    .foregroundStyle(AppColors.primary)
                }
                .chartXAxis {
                    AxisMarks { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                Text(shortDateLabel(date))
                                    .font(AppFonts.labelSmall)
                            }
                        }
                        AxisGridLine()
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        if let v = value.as(Int.self) {
                            AxisValueLabel { Text("\(v)m") }
                            AxisGridLine()
                        }
                    }
                }
                .frame(height: 160)
            }
        }
    }

    private func shortDateLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        return f.string(from: date)
    }
}

// MARK: - SettingsView

struct SettingsView: View {
    @Binding var colorSchemePreference: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $colorSchemePreference) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
