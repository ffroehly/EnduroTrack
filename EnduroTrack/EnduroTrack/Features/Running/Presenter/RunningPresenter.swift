// RunningPresenter.swift
// EnduroTrack › Features › Running › Presenter
//
// VIPER: Presenter layer for the Running module.

import Foundation
import Domain
import Combine

/// Drives the Running screen. Observed by RunningView.
@MainActor
final class RunningPresenter: ObservableObject, RunningPresenterProtocol {

    // MARK: - Published State

    @Published private(set) var state: RunningViewState = .idle

    // MARK: - VIPER Dependencies

    private let interactor: RunningInteractorProtocol
    private let router: RunningRouterProtocol

    // MARK: - Init

    init(interactor: RunningInteractorProtocol, router: RunningRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - RunningPresenterProtocol

    func viewDidAppear() async {
        state = .idle
    }

    func didTapStartRun() {
        Task {
            state = .loading
            do {
                let session = try await interactor.startRun()
                state = .running(session: session)
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didTapStopRun() {
        guard case .running(let session) = state else { return }
        Task {
            do {
                let stopped = try await interactor.stopRun(session)
                state = .stopped(session: stopped)
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didTapHistory() {
        router.navigateToRunHistory()
    }
}
