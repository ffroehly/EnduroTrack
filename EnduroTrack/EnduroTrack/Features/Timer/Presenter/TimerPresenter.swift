// TimerPresenter.swift
// EnduroTrack › Features › Timer › Presenter
//
// VIPER: Presenter layer for the Timer module.
// Manages timer countdown logic using async/await and a countdown task.

import Foundation
import Domain

/// Drives the Timer screen. Observed by TimerView.
@MainActor
final class TimerPresenter: ObservableObject, TimerPresenterProtocol {

    // MARK: - Published State

    @Published private(set) var state: TimerViewState = .loading

    // MARK: - VIPER Dependencies

    private let interactor: TimerInteractorProtocol
    private let router: TimerRouterProtocol

    // MARK: - Private Timer State

    private var countdownTask: Task<Void, Never>?
    private var currentSession: TimerSession?
    private var currentIntervalIndex: Int = 0
    private var remainingSeconds: Int = 0

    // MARK: - Init

    init(interactor: TimerInteractorProtocol, router: TimerRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - TimerPresenterProtocol

    func viewDidAppear() async {
        state = .loading
        do {
            let presets = try await interactor.fetchTimerPresets()
            state = .idle(presets: presets)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    func didSelectSession(_ session: TimerSession) {
        currentSession = session
    }

    func didTapStartTimer(session: TimerSession) {
        currentSession = session
        currentIntervalIndex = 0
        guard let firstInterval = session.intervals.first else { return }
        remainingSeconds = firstInterval.durationSeconds
        state = .running(
            session: session,
            remainingSeconds: remainingSeconds,
            currentIntervalIndex: 0
        )
        startCountdown()
    }

    func didTapPauseTimer() {
        countdownTask?.cancel()
        countdownTask = nil
        guard let session = currentSession else { return }
        state = .paused(
            session: session,
            remainingSeconds: remainingSeconds,
            currentIntervalIndex: currentIntervalIndex
        )
    }

    func didTapResumeTimer() {
        guard let session = currentSession else { return }
        state = .running(
            session: session,
            remainingSeconds: remainingSeconds,
            currentIntervalIndex: currentIntervalIndex
        )
        startCountdown()
    }

    func didTapStopTimer() {
        countdownTask?.cancel()
        countdownTask = nil
        Task {
            let presets = (try? await interactor.fetchTimerPresets()) ?? []
            state = .idle(presets: presets)
        }
    }

    func didTapCreateNewTimer() {
        router.navigateToCreateTimer()
    }

    // MARK: - Private Countdown Logic

    private func startCountdown() {
        countdownTask = Task { @MainActor [weak self] in
            guard let self else { return }
            while remainingSeconds > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                remainingSeconds -= 1
                guard let session = currentSession else { return }
                state = .running(
                    session: session,
                    remainingSeconds: remainingSeconds,
                    currentIntervalIndex: currentIntervalIndex
                )
            }
            await advanceToNextInterval()
        }
    }

    private func advanceToNextInterval() async {
        guard let session = currentSession else { return }
        currentIntervalIndex += 1
        if currentIntervalIndex < session.intervals.count {
            remainingSeconds = session.intervals[currentIntervalIndex].durationSeconds
            state = .running(
                session: session,
                remainingSeconds: remainingSeconds,
                currentIntervalIndex: currentIntervalIndex
            )
            startCountdown()
        } else {
            state = .finished(session: session)
        }
    }
}
