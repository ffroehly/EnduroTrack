// RunningRouter.swift
// EnduroTrack › Features › Running › Router
//
// VIPER: Router layer for the Running module.

import SwiftUI
import Domain
import Combine

/// Drives navigation from the Running screen.
@MainActor
final class RunningRouter: RunningRouterProtocol, ObservableObject {

    // MARK: - Navigation State

    @Published var navigationPath = NavigationPath()

    // MARK: - RunningRouterProtocol

    func navigateToRunHistory() {
        navigationPath.append(RunningDestination.history)
    }

    func navigateToRunDetail(_ session: RunSession) {
        navigationPath.append(RunningDestination.detail(session))
    }
}

// MARK: - Destination Types

enum RunningDestination: Hashable {
    case history
    case detail(RunSession)
}
