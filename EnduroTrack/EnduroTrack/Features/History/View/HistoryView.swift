// HistoryView.swift
// EnduroTrack › Features › History

import SwiftUI
import Charts
import Domain
import DesignSystem

struct HistoryView: View {

    @StateObject private var presenter: HistoryPresenter
    @State private var selectedSummary: DailySessionSummary?

    init(presenter: HistoryPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("History")
                .navigationBarTitleDisplayMode(.large)
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

        case .loaded(let sessions, let summaries, let month):
            loadedView(sessions: sessions, summaries: summaries, month: month)

        case .empty:
            emptyView

        case .error(let message):
            errorView(message: message)
        }
    }

    private func loadedView(sessions: [ExerciseSession], summaries: [DailySessionSummary], month: Date) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // Month navigation header
                monthNavigationView(month: month)
                    .padding(.horizontal)

                // Monthly chart
                if summaries.isEmpty {
                    Text("No sessions this month")
                        .font(AppFonts.bodyMedium)
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(height: 150)
                } else {
                    monthlyChart(summaries: summaries, month: month)
                        .padding(.horizontal)
                }

                Divider()

                // Session list
                VStack(alignment: .leading, spacing: 0) {
                    Text("All Sessions")
                        .font(AppFonts.headlineLarge)
                        .padding(.horizontal)
                        .padding(.bottom, 8)

                    ForEach(sessions) { session in
                        SessionRowView(session: session)
                        Divider().padding(.leading)
                    }
                }
            }
            .padding(.vertical)
        }
    }

    private func monthNavigationView(month: Date) -> some View {
        HStack {
            Button {
                selectedSummary = nil
                presenter.didTapPreviousMonth()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
            }
            Spacer()
            Text(monthTitle(month))
                .font(AppFonts.headlineLarge)
            Spacer()
            Button {
                selectedSummary = nil
                presenter.didTapNextMonth()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3.bold())
            }
        }
    }

    private func monthlyChart(summaries: [DailySessionSummary], month: Date) -> some View {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: month)
        let monthStart = interval?.start ?? month
        let monthEnd = interval?.end ?? month

        return VStack(alignment: .leading, spacing: 8) {
            Text("Sessions this month")
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.textSecondary)

            Chart(summaries) { summary in
                BarMark(
                    x: .value("Day", summary.date, unit: .day),
                    y: .value("Duration", summary.totalDurationSeconds)
                )
                .foregroundStyle(summary.id == selectedSummary?.id ? AppColors.secondary : AppColors.primary)
                .cornerRadius(4)
                .annotation(position: .top, spacing: 4, overflowResolution: .init(x: .fit, y: .fit)) {
                    if summary.id == selectedSummary?.id {
                        dayAnnotation(for: summary)
                    }
                }
            }
            .chartXScale(domain: monthStart...monthEnd)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 7)) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel {
                            Text(dayLabel(date))
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
                            guard let plotFrame = proxy.plotFrame else { return }
                            let x = location.x - geometry[plotFrame].origin.x
                            guard let tappedDate: Date = proxy.value(atX: x) else { return }
                            let nearest = summaries.min {
                                abs($0.date.timeIntervalSince(tappedDate)) <
                                abs($1.date.timeIntervalSince(tappedDate))
                            }
                            if selectedSummary?.id == nearest?.id {
                                selectedSummary = nil
                            } else {
                                selectedSummary = nearest
                            }
                        }
                }
            }
            .frame(height: 200)
        }
    }

    private func dayAnnotation(for summary: DailySessionSummary) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(shortDayLabel(summary.date))
                .font(AppFonts.labelSmall.bold())
                .foregroundStyle(.white)
            ForEach(summary.sessions) { session in
                HStack(spacing: 6) {
                    Text(session.exerciseTitle)
                        .font(AppFonts.labelSmall)
                        .foregroundStyle(.white)
                    Spacer(minLength: 8)
                    Text(durationLabel(session.durationSeconds))
                        .font(AppFonts.labelSmall)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(AppColors.primary)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.primary)
            Text("No history yet")
                .font(AppFonts.headlineLarge)
            Text("Complete an exercise to see your history here.")
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
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

    private func monthTitle(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: date)
    }

    private static let dayLabelFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()

    private static let shortDayLabelFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        return f
    }()

    private func dayLabel(_ date: Date) -> String {
        Self.dayLabelFormatter.string(from: date)
    }

    private func shortDayLabel(_ date: Date) -> String {
        Self.shortDayLabelFormatter.string(from: date)
    }

    private func durationLabel(_ seconds: Int) -> String {
        if seconds < 60 { return "\(seconds)s" }
        let m = seconds / 60
        let s = seconds % 60
        return s == 0 ? "\(m)m" : "\(m)m \(s)s"
    }
}

// MARK: - SessionRowView

struct SessionRowView: View {
    let session: ExerciseSession

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.exerciseTitle)
                    .font(AppFonts.headlineMedium)
                    .foregroundStyle(AppColors.textPrimary)
                Text(formattedDate(session.completedAt))
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Spacer()
            Text(FormattedDuration(totalSeconds: session.durationSeconds).longDisplay)
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }
}
