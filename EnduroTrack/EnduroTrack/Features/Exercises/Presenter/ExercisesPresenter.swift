// ExercisesPresenter.swift
// EnduroTrack › Features › Exercises

import Foundation
import Domain
import Combine

@MainActor
final class ExercisesPresenter: ObservableObject, ExercisesPresenterProtocol {

    @Published private(set) var state: ExercisesViewState = .loading

    private let interactor: ExercisesInteractorProtocol
    private let router: ExercisesRouterProtocol

    // Timer state
    private var countdownTask: Task<Void, Never>?
    private var currentExercise: Exercise?
    private var currentPhase: TimerPhase = .warmup
    private var remainingSeconds: Int = 0
    private var elapsedSeconds: Int = 0
    private var phaseElapsedSeconds: Int = 0
    private var timerStartTime: Date = Date()

    init(interactor: ExercisesInteractorProtocol, router: ExercisesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidAppear() async {
        switch state {
        case .timerRunning, .timerPaused, .timerFinished:
            return
        default:
            await loadExercises()
        }
    }

    private func loadExercises() async {
        state = .loading
        do {
            let exercises = try await interactor.fetchExercises()
            state = exercises.isEmpty ? .empty : .list(exercises: exercises)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    func didTapCreateExercise() {
        state = .showingCreateForm
    }

    func didTapDeleteExercise(id: UUID) {
        Task {
            do {
                try await interactor.deleteExercise(id: id)
                await loadExercises()
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didTapEditExercise(_ exercise: Exercise) {
        state = .showingEditForm(exercise: exercise)
    }

    func didTapStartExercise(_ exercise: Exercise) {
        currentExercise = exercise
        elapsedSeconds = 0
        timerStartTime = Date()
        startPhase(.warmup, exercise: exercise)
    }

    func didSaveNewExercise(title: String, warmupSeconds: Int, activeSeconds: Int, restSeconds: Int, repetitions: Int, recoverySeconds: Int?) {
        Task {
            do {
                _ = try await interactor.createExercise(
                    title: title,
                    warmupSeconds: warmupSeconds,
                    activeSeconds: activeSeconds,
                    restSeconds: restSeconds,
                    repetitions: repetitions,
                    recoverySeconds: recoverySeconds
                )
                await loadExercises()
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didSaveEditedExercise(_ exercise: Exercise, title: String, warmupSeconds: Int, activeSeconds: Int, restSeconds: Int, repetitions: Int, recoverySeconds: Int?) {
        Task {
            do {
                let updated = Exercise(
                    id: exercise.id,
                    title: title,
                    warmupSeconds: warmupSeconds,
                    activeSeconds: activeSeconds,
                    restSeconds: restSeconds,
                    repetitions: repetitions,
                    recoverySeconds: recoverySeconds,
                    createdAt: exercise.createdAt
                )
                _ = try await interactor.updateExercise(updated)
                await loadExercises()
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didTapPauseTimer() {
        countdownTask?.cancel()
        countdownTask = nil
        guard let exercise = currentExercise else { return }
        state = .timerPaused(
            exercise: exercise,
            phase: currentPhase,
            remainingSeconds: remainingSeconds,
            elapsedSeconds: elapsedSeconds
        )
    }

    func didTapResumeTimer() {
        guard let exercise = currentExercise else { return }
        state = .timerRunning(
            exercise: exercise,
            phase: currentPhase,
            remainingSeconds: remainingSeconds,
            elapsedSeconds: elapsedSeconds
        )
        startCountdown(exercise: exercise)
    }

    func didTapStopTimer() {
        countdownTask?.cancel()
        countdownTask = nil
        Task {
            await loadExercises()
        }
    }

    func didTapPreviousStep() {
        countdownTask?.cancel()
        countdownTask = nil
        guard let exercise = currentExercise else { return }
        if phaseElapsedSeconds >= 1 {
            startPhase(currentPhase, exercise: exercise)
        } else {
            startPhase(previousPhase(for: currentPhase, exercise: exercise), exercise: exercise)
        }
    }

    func didTapNextStep() {
        countdownTask?.cancel()
        countdownTask = nil
        guard let exercise = currentExercise else { return }
        countdownTask = Task { @MainActor [weak self] in
            guard let self, !Task.isCancelled else { return }
            await advancePhase(exercise: exercise)
        }
    }

    // MARK: - Timer Logic

    private func startPhase(_ phase: TimerPhase, exercise: Exercise) {
        currentPhase = phase
        phaseElapsedSeconds = 0
        switch phase {
        case .warmup:
            remainingSeconds = exercise.warmupSeconds
        case .active:
            remainingSeconds = exercise.activeSeconds
        case .rest:
            remainingSeconds = exercise.restSeconds
        case .recovery:
            remainingSeconds = exercise.recoverySeconds ?? 0
        }
        state = .timerRunning(
            exercise: exercise,
            phase: phase,
            remainingSeconds: remainingSeconds,
            elapsedSeconds: elapsedSeconds
        )
        startCountdown(exercise: exercise)
    }

    private func startCountdown(exercise: Exercise) {
        countdownTask = Task { @MainActor [weak self] in
            guard let self else { return }
            while remainingSeconds > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                remainingSeconds -= 1
                elapsedSeconds += 1
                phaseElapsedSeconds += 1
                state = .timerRunning(
                    exercise: exercise,
                    phase: currentPhase,
                    remainingSeconds: remainingSeconds,
                    elapsedSeconds: elapsedSeconds
                )
            }
            await advancePhase(exercise: exercise)
        }
    }

    private func advancePhase(exercise: Exercise) async {
        switch currentPhase {
        case .warmup:
            startPhase(.active(rep: 1), exercise: exercise)
        case .active(let rep):
            if exercise.restSeconds > 0 {
                startPhase(.rest(rep: rep), exercise: exercise)
            } else {
                await advanceAfterRest(rep: rep, exercise: exercise)
            }
        case .rest(let rep):
            await advanceAfterRest(rep: rep, exercise: exercise)
        case .recovery:
            await finishTimer(exercise: exercise)
        }
    }

    private func advanceAfterRest(rep: Int, exercise: Exercise) async {
        if rep < exercise.repetitions {
            startPhase(.active(rep: rep + 1), exercise: exercise)
        } else if let recovery = exercise.recoverySeconds, recovery > 0 {
            startPhase(.recovery, exercise: exercise)
        } else {
            await finishTimer(exercise: exercise)
        }
    }

    private func previousPhase(for phase: TimerPhase, exercise: Exercise) -> TimerPhase {
        switch phase {
        case .warmup:
            return .warmup
        case .active(let rep):
            if rep <= 1 {
                return .warmup
            } else if exercise.restSeconds > 0 {
                return .rest(rep: rep - 1)
            } else {
                return .active(rep: rep - 1)
            }
        case .rest(let rep):
            return .active(rep: rep)
        case .recovery:
            if exercise.restSeconds > 0 {
                return .rest(rep: exercise.repetitions)
            } else {
                return .active(rep: exercise.repetitions)
            }
        }
    }

    private func finishTimer(exercise: Exercise) async {
        let duration = elapsedSeconds
        let session = ExerciseSession(
            exerciseId: exercise.id,
            exerciseTitle: exercise.title,
            durationSeconds: duration
        )
        _ = try? await interactor.saveSession(session)
        state = .timerFinished(exercise: exercise, durationSeconds: duration)
    }
}
