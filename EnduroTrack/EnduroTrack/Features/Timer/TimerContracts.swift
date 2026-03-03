// TimerContracts.swift
// EnduroTrack › Features › Timer
//
// VIPER contracts for the Timer module.

import Foundation
import Domain

// MARK: - View Protocol

@MainActor
protocol TimerViewProtocol: AnyObject {
    func render(state: TimerViewState)
}

// MARK: - Presenter Protocol

@MainActor
protocol TimerPresenterProtocol: AnyObject {
    func viewDidAppear() async
    func didSelectSession(_ session: TimerSession)
    func didTapStartTimer(session: TimerSession)
    func didTapPauseTimer()
    func didTapResumeTimer()
    func didTapStopTimer()
    func didTapCreateNewTimer()
}

// MARK: - Interactor Protocol

protocol TimerInteractorProtocol: AnyObject {
    func fetchTimerPresets() async throws -> [TimerSession]
}

// MARK: - Router Protocol

@MainActor
protocol TimerRouterProtocol: AnyObject {
    func navigateToCreateTimer()
}

// MARK: - View State

enum TimerViewState: Equatable {
    case loading
    case idle(presets: [TimerSession])
    case running(session: TimerSession, remainingSeconds: Int, currentIntervalIndex: Int)
    case paused(session: TimerSession, remainingSeconds: Int, currentIntervalIndex: Int)
    case finished(session: TimerSession)
    case error(message: String)
}
