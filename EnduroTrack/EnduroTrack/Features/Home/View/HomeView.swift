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
    @State private var selectedSession: ExerciseSession?

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
                Chart(Array(sessions)) { session in
                    LineMark(
                        x: .value("Date", session.completedAt),
                        y: .value("Duration (s)", session.durationSeconds)
                    )
                    .foregroundStyle(AppColors.primary)
                    PointMark(
                        x: .value("Date", session.completedAt),
                        y: .value("Duration (s)", session.durationSeconds)
                    )
                    .foregroundStyle(session.id == selectedSession?.id ? AppColors.secondary : AppColors.primary)
                    .symbolSize(session.id == selectedSession?.id ? 120 : 60)
                    .annotation(position: .automatic, spacing: 6, overflowResolution: .init(x: .fit, y: .fit)) {
                        if session.id == selectedSession?.id {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(session.exerciseTitle)
                                    .font(AppFonts.labelSmall)
                                    .foregroundStyle(.white)
                                Text(shortDateAndTimeLabel(session.completedAt))
                                    .font(AppFonts.labelSmall)
                                    .foregroundStyle(.white.opacity(0.8))
                                Text(durationLabel(session.durationSeconds))
                                    .font(AppFonts.labelSmall)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppColors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .accessibilityLabel("\(session.exerciseTitle), \(shortDateAndTimeLabel(session.completedAt)), \(durationLabel(session.durationSeconds))")
                        }
                    }
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
                            AxisValueLabel { Text(durationLabel(v)) }
                            AxisGridLine()
                        }
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture { location in
                                guard !sessions.isEmpty, let plotFrame = proxy.plotFrame else { return }
                                let x = location.x - geometry[plotFrame].origin.x
                                guard let tappedDate: Date = proxy.value(atX: x) else { return }
                                let nearest = sessions.min {
                                    abs($0.completedAt.timeIntervalSince(tappedDate)) <
                                    abs($1.completedAt.timeIntervalSince(tappedDate))
                                }
                                if selectedSession?.id == nearest?.id {
                                    selectedSession = nil
                                } else {
                                    selectedSession = nearest
                                }
                            }
                    }
                }
                .frame(height: 200)
            }
        }
    }

    private static let shortDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d/MM"
        return f
    }()
    
    private static let shortDateAndTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d/MM - HH:mm"
        return f
    }()

    private func shortDateLabel(_ date: Date) -> String {
        Self.shortDateFormatter.string(from: date)
    }
    
    private func shortDateAndTimeLabel(_ date: Date) -> String {
        Self.shortDateAndTimeFormatter.string(from: date)
    }

    private func durationLabel(_ seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)s"
        }
        let m = seconds / 60
        let s = seconds % 60
        return s == 0 ? "\(m)m" : "\(m)m \(s)s"
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
