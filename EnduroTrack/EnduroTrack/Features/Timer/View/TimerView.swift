// TimerView.swift (History feature)
// EnduroTrack › Features › Timer (History)

import SwiftUI
import Charts
import Domain
import DesignSystem

struct HistoryView: View {

    @StateObject private var presenter: HistoryPresenter

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
                presenter.didTapNextMonth()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3.bold())
            }
        }
    }

    private func monthlyChart(summaries: [DailySessionSummary], month: Date) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sessions this month")
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.textSecondary)

            Chart(summaries) { summary in
                BarMark(
                    x: .value("Day", summary.date, unit: .day),
                    y: .value("Duration (min)", summary.totalDurationMinutes)
                )
                .foregroundStyle(AppColors.primary)
                .cornerRadius(4)
            }
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
                        AxisValueLabel { Text("\(v)m") }
                        AxisGridLine()
                    }
                }
            }
            .frame(height: 180)
        }
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

    private func dayLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: date)
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
