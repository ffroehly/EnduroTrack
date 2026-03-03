// RunningView.swift (Schedule feature)
// EnduroTrack › Features › Running (Schedule)

import SwiftUI
import Domain
import DesignSystem

struct ScheduleView: View {

    @StateObject private var presenter: SchedulePresenter

    init(presenter: SchedulePresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Schedule")
                .navigationBarTitleDisplayMode(.large)
                .toolbar { toolbarContent }
        }
        .task {
            await presenter.viewDidAppear()
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                presenter.didTapAddSchedule()
            } label: {
                Image(systemName: "plus")
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .loading:
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .list(let schedules, let exercises):
            scheduleListView(schedules: schedules, exercises: exercises)

        case .empty(let exercises):
            emptyView(exercises: exercises)

        case .showingCreateForm(let exercises):
            ScheduleFormView(
                mode: .create,
                exercises: exercises,
                onSave: { exerciseId, daySchedules in
                    presenter.didSaveNewSchedule(exerciseId: exerciseId, daySchedules: daySchedules)
                },
                onCancel: {
                    Task { await presenter.viewDidAppear() }
                }
            )

        case .showingEditForm(let schedule, let exercises):
            ScheduleFormView(
                mode: .edit(schedule),
                exercises: exercises,
                onSave: { exerciseId, daySchedules in
                    presenter.didSaveEditedSchedule(schedule, exerciseId: exerciseId, daySchedules: daySchedules)
                },
                onCancel: {
                    Task { await presenter.viewDidAppear() }
                }
            )

        case .error(let message):
            errorView(message: message)
        }
    }

    private func scheduleListView(schedules: [ScheduleViewModel], exercises: [Exercise]) -> some View {
        List {
            ForEach(schedules) { vm in
                ScheduleRowView(viewModel: vm) {
                    presenter.didTapEditSchedule(vm.schedule)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        presenter.didTapDeleteSchedule(id: vm.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        presenter.didTapEditSchedule(vm.schedule)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func emptyView(exercises: [Exercise]) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.primary)
            Text("No schedules yet")
                .font(AppFonts.headlineLarge)
            if exercises.isEmpty {
                Text("Create an exercise first, then schedule it.")
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("Tap + to schedule your exercises.")
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                PrimaryButton(title: "Add Schedule") {
                    presenter.didTapAddSchedule()
                }
                .padding(.horizontal, 40)
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
            Text(message)
                .font(AppFonts.bodyMedium)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ScheduleRowView

struct ScheduleRowView: View {
    let viewModel: ScheduleViewModel
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.exerciseTitle)
                .font(AppFonts.headlineMedium)
                .foregroundStyle(AppColors.textPrimary)
            ForEach(viewModel.schedule.daySchedules, id: \.dayOfWeek) { day in
                HStack {
                    Text(day.dayOfWeek.displayName)
                        .font(AppFonts.bodyMedium)
                    Spacer()
                    Text(day.reminderTimeFormatted)
                        .font(AppFonts.bodyMedium)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .contentShape(Rectangle())
    }
}

// MARK: - ScheduleFormView

enum ScheduleFormMode {
    case create
    case edit(Schedule)
}

struct ScheduleFormView: View {
    let mode: ScheduleFormMode
    let exercises: [Exercise]
    let onSave: (UUID, [DaySchedule]) -> Void
    let onCancel: () -> Void

    @State private var selectedExerciseId: UUID?
    @State private var selectedDays: Set<DayOfWeek> = []
    @State private var reminderTimes: [DayOfWeek: Date] = [:]

    init(mode: ScheduleFormMode, exercises: [Exercise], onSave: @escaping (UUID, [DaySchedule]) -> Void, onCancel: @escaping () -> Void) {
        self.mode = mode
        self.exercises = exercises
        self.onSave = onSave
        self.onCancel = onCancel
        switch mode {
        case .create:
            _selectedExerciseId = State(initialValue: exercises.first?.id)
            _selectedDays = State(initialValue: [])
            _reminderTimes = State(initialValue: [:])
        case .edit(let schedule):
            _selectedExerciseId = State(initialValue: schedule.exerciseId)
            let days = Set(schedule.daySchedules.map { $0.dayOfWeek })
            _selectedDays = State(initialValue: days)
            var times: [DayOfWeek: Date] = [:]
            for ds in schedule.daySchedules {
                var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                comps.hour = ds.reminderHour
                comps.minute = ds.reminderMinute
                times[ds.dayOfWeek] = Calendar.current.date(from: comps) ?? Date()
            }
            _reminderTimes = State(initialValue: times)
        }
    }

    private var navigationTitle: String {
        switch mode {
        case .create: return "New Schedule"
        case .edit:   return "Edit Schedule"
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise") {
                    if exercises.isEmpty {
                        Text("No exercises available. Create one first.")
                            .foregroundStyle(AppColors.textSecondary)
                    } else {
                        Picker("Exercise", selection: Binding(
                            get: { selectedExerciseId ?? exercises[0].id },
                            set: { selectedExerciseId = $0 }
                        )) {
                            ForEach(exercises) { exercise in
                                Text(exercise.title).tag(exercise.id)
                            }
                        }
                    }
                }
                Section("Days") {
                    ForEach(DayOfWeek.allCases, id: \.self) { day in
                        VStack {
                            Toggle(day.displayName, isOn: Binding(
                                get: { selectedDays.contains(day) },
                                set: { isOn in
                                    if isOn {
                                        selectedDays.insert(day)
                                        if reminderTimes[day] == nil {
                                            var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                                            comps.hour = 8
                                            comps.minute = 0
                                            reminderTimes[day] = Calendar.current.date(from: comps) ?? Date()
                                        }
                                    } else {
                                        selectedDays.remove(day)
                                    }
                                }
                            ))
                            if selectedDays.contains(day) {
                                DatePicker(
                                    "Time",
                                    selection: Binding(
                                        get: { reminderTimes[day] ?? Date() },
                                        set: { reminderTimes[day] = $0 }
                                    ),
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let exerciseId = selectedExerciseId else { return }
                        let daySchedules = selectedDays.sorted(by: { $0.rawValue < $1.rawValue }).compactMap { day -> DaySchedule? in
                            guard let date = reminderTimes[day] else { return nil }
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                            return DaySchedule(
                                dayOfWeek: day,
                                reminderHour: comps.hour ?? 8,
                                reminderMinute: comps.minute ?? 0
                            )
                        }
                        onSave(exerciseId, daySchedules)
                    }
                    .disabled(selectedExerciseId == nil || selectedDays.isEmpty)
                }
            }
        }
    }
}
