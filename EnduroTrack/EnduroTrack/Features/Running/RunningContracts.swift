// RunningContracts.swift
// EnduroTrack › Features › Running
//
// VIPER contracts for the Running module.

import Foundation
import Domain

// MARK: - View Protocol

@MainActor
protocol RunningViewProtocol: AnyObject {
    func render(state: RunningViewState)
}

// MARK: - Presenter Protocol

@MainActor
protocol RunningPresenterProtocol: AnyObject {
    func viewDidAppear() async
    func didTapStartRun()
    func didTapStopRun()
    func didTapHistory()
}

// MARK: - Interactor Protocol

protocol RunningInteractorProtocol: AnyObject {
    func startRun() async throws -> RunSession
    func stopRun(_ session: RunSession) async throws -> RunSession
    func fetchRunHistory() async throws -> [RunSession]
}

// MARK: - Router Protocol

@MainActor
protocol RunningRouterProtocol: AnyObject {
    func navigateToRunHistory()
    func navigateToRunDetail(_ session: RunSession)
}

// MARK: - View State

enum RunningViewState: Equatable {
    case idle
    case loading
    case running(session: RunSession)
    case stopped(session: RunSession)
    case error(message: String)
}
