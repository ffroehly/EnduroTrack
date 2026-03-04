// ExercisesView.swift
// EnduroTrack › Features › Exercises

import SwiftUI
import Domain
import DesignSystem

struct ExercisesView: View {

    @StateObject private var presenter: ExercisesPresenter

    init(presenter: ExercisesPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Exercises")
                .navigationBarTitleDisplayMode(.large)
                .toolbar { toolbarContent }
        }
        .task {
            await presenter.viewDidAppear()
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        switch presenter.state {
        case .list, .empty:
            ToolbarItem(placement: .primaryAction) {
                Button {
                    presenter.didTapCreateExercise()
                } label: {
                    Image(systemName: "plus")
                }
            }
        default:
            ToolbarItem(placement: .primaryAction) {
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .loading:
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .list(let exercises):
            exerciseListView(exercises: exercises)

        case .empty:
            emptyView

        case .showingCreateForm:
            ExerciseFormView(
                mode: .create,
                onSave: { title, warmup, active, rest, reps, recovery in
                    presenter.didSaveNewExercise(
                        title: title,
                        warmupSeconds: warmup,
                        activeSeconds: active,
                        restSeconds: rest,
                        repetitions: reps,
                        recoverySeconds: recovery
                    )
                },
                onCancel: {
                    Task { await presenter.viewDidAppear() }
                }
            )

        case .showingEditForm(let exercise):
            ExerciseFormView(
                mode: .edit(exercise),
                onSave: { title, warmup, active, rest, reps, recovery in
                    presenter.didSaveEditedExercise(
                        exercise,
                        title: title,
                        warmupSeconds: warmup,
                        activeSeconds: active,
                        restSeconds: rest,
                        repetitions: reps,
                        recoverySeconds: recovery
                    )
                },
                onCancel: {
                    Task { await presenter.viewDidAppear() }
                }
            )

        case .timerRunning(let exercise, let phase, let remaining, let elapsed):
            TimerRunView(
                exercise: exercise,
                phase: phase,
                remainingSeconds: remaining,
                elapsedSeconds: elapsed,
                isPaused: false,
                onPause: { presenter.didTapPauseTimer() },
                onResume: { presenter.didTapResumeTimer() },
                onStop: { presenter.didTapStopTimer() },
                onBack: { presenter.didTapPreviousStep() },
                onNext: { presenter.didTapNextStep() }
            )

        case .timerPaused(let exercise, let phase, let remaining, let elapsed):
            TimerRunView(
                exercise: exercise,
                phase: phase,
                remainingSeconds: remaining,
                elapsedSeconds: elapsed,
                isPaused: true,
                onPause: { presenter.didTapPauseTimer() },
                onResume: { presenter.didTapResumeTimer() },
                onStop: { presenter.didTapStopTimer() },
                onBack: { presenter.didTapPreviousStep() },
                onNext: { presenter.didTapNextStep() }
            )

        case .timerFinished(let exercise, let duration):
            timerFinishedView(exercise: exercise, duration: duration)

        case .error(let message):
            errorView(message: message)
        }
    }

    private func exerciseListView(exercises: [Exercise]) -> some View {
        List {
            ForEach(exercises) { exercise in
                ExerciseRowView(exercise: exercise) {
                    presenter.didTapStartExercise(exercise)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        presenter.didTapDeleteExercise(id: exercise.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        presenter.didTapEditExercise(exercise)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.primary)
            Text("No exercises yet")
                .font(AppFonts.headlineLarge)
            Text("Tap + to create your first exercise.")
                .font(AppFonts.bodyMedium)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            PrimaryButton(title: "New Exercise") {
                presenter.didTapCreateExercise()
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func timerFinishedView(exercise: Exercise, duration: Int) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(AppColors.success)
            Text("Done!")
                .font(AppFonts.displayMedium)
            Text(exercise.title)
                .font(AppFonts.headlineLarge)
            StatBadge(
                label: "Duration",
                value: FormattedDuration(totalSeconds: duration).longDisplay,
                icon: "clock"
            )
            PrimaryButton(title: "Back to Exercises") {
                Task { await presenter.didTapBackToExercises() }
            }
            .padding(.horizontal, 40)
        }
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

// MARK: - ExerciseRowView

struct ExerciseRowView: View {
    let exercise: Exercise
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.title)
                    .font(AppFonts.headlineMedium)
                    .foregroundStyle(AppColors.textPrimary)
                Text("\(exercise.repetitions) rep(s) · \(exercise.activeSeconds)s active · \(exercise.restSeconds)s rest")
                    .font(AppFonts.bodyMedium)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ExerciseFormView

enum ExerciseFormMode {
    case create
    case edit(Exercise)
}

struct ExerciseFormView: View {
    let mode: ExerciseFormMode
    let onSave: (String, Int, Int, Int, Int, Int?) -> Void
    let onCancel: () -> Void

    @State private var title: String
    @State private var warmupSeconds: Int
    @State private var activeSeconds: Int
    @State private var restSeconds: Int
    @State private var repetitions: Int
    @State private var hasRecovery: Bool
    @State private var recoverySeconds: Int

    init(mode: ExerciseFormMode, onSave: @escaping (String, Int, Int, Int, Int, Int?) -> Void, onCancel: @escaping () -> Void) {
        self.mode = mode
        self.onSave = onSave
        self.onCancel = onCancel
        switch mode {
        case .create:
            _title = State(initialValue: "")
            _warmupSeconds = State(initialValue: 5)
            _activeSeconds = State(initialValue: 30)
            _restSeconds = State(initialValue: 10)
            _repetitions = State(initialValue: 8)
            _hasRecovery = State(initialValue: false)
            _recoverySeconds = State(initialValue: 60)
        case .edit(let exercise):
            _title = State(initialValue: exercise.title)
            _warmupSeconds = State(initialValue: exercise.warmupSeconds)
            _activeSeconds = State(initialValue: exercise.activeSeconds)
            _restSeconds = State(initialValue: exercise.restSeconds)
            _repetitions = State(initialValue: exercise.repetitions)
            _hasRecovery = State(initialValue: exercise.recoverySeconds != nil)
            _recoverySeconds = State(initialValue: exercise.recoverySeconds ?? 60)
        }
    }

    private var navigationTitle: String {
        switch mode {
        case .create: return "New Exercise"
        case .edit:   return "Edit Exercise"
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Exercise name", text: $title)
                }
                Section("Timer Configuration") {
                    Stepper("Warmup: \(warmupSeconds)s", value: $warmupSeconds, in: 0...60, step: 5)
                    Stepper("Active: \(activeSeconds)s", value: $activeSeconds, in: 5...300, step: 5)
                    Stepper("Rest: \(restSeconds)s", value: $restSeconds, in: 0...300, step: 5)
                    Stepper("Repetitions: \(repetitions)", value: $repetitions, in: 1...100)
                }
                Section("Recovery") {
                    Toggle("Add recovery", isOn: $hasRecovery)
                    if hasRecovery {
                        Stepper("Recovery: \(recoverySeconds)s", value: $recoverySeconds, in: 5...600, step: 5)
                    }
                }
                Section("Summary") {
                    let total = warmupSeconds + (activeSeconds + restSeconds) * repetitions + (hasRecovery ? recoverySeconds : 0)
                    Text("Total duration: \(FormattedDuration(totalSeconds: total).longDisplay)")
                        .foregroundStyle(AppColors.textSecondary)
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
                        onSave(
                            title,
                            warmupSeconds,
                            activeSeconds,
                            restSeconds,
                            repetitions,
                            hasRecovery ? recoverySeconds : nil
                        )
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - TimerRunView

struct TimerRunView: View {
    let exercise: Exercise
    let phase: TimerPhase
    let remainingSeconds: Int
    let elapsedSeconds: Int
    let isPaused: Bool
    let onPause: () -> Void
    let onResume: () -> Void
    let onStop: () -> Void
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Text(exercise.title)
                .font(AppFonts.headlineLarge)

            Text(phaseLabel)
                .font(AppFonts.headlineMedium)
                .foregroundStyle(phaseColor)

            Text(FormattedDuration(totalSeconds: remainingSeconds).display)
                .font(AppFonts.timerDisplay)
                .foregroundStyle(AppColors.textPrimary)
                .monospacedDigit()

            progressText

            HStack(spacing: 16) {
                PrimaryButton(title: "← Back", style: .outlined, action: onBack)
                PrimaryButton(title: "Next →", style: .outlined, action: onNext)
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                if isPaused {
                    PrimaryButton(title: "Resume", action: onResume)
                    PrimaryButton(title: "Stop", style: .outlined, action: onStop)
                } else {
                    PrimaryButton(title: "Pause", style: .outlined, action: onPause)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var phaseLabel: String {
        switch phase {
        case .warmup:           return "Warm Up"
        case .active(let rep):  return "Active — Rep \(rep)/\(exercise.repetitions)"
        case .rest(let rep):    return "Rest — Rep \(rep)/\(exercise.repetitions)"
        case .recovery:         return "Recovery"
        }
    }

    private var phaseColor: Color {
        switch phase {
        case .warmup:   return AppColors.warning
        case .active:   return AppColors.primary
        case .rest:     return AppColors.success
        case .recovery: return AppColors.textSecondary
        }
    }

    private var progressText: some View {
        Text("Elapsed: \(FormattedDuration(totalSeconds: elapsedSeconds).longDisplay)")
            .font(AppFonts.bodyMedium)
            .foregroundStyle(AppColors.textSecondary)
    }
}
