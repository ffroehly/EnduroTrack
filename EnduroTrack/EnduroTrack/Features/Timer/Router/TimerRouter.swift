// TimerRouter.swift
// EnduroTrack › Features › Timer › Router
//
// VIPER: Router layer for the Timer module.

import SwiftUI
import Domain

/// Drives navigation from the Timer screen.
@MainActor
final class TimerRouter: TimerRouterProtocol, ObservableObject {

    // MARK: - Navigation State

    @Published var sheetDestination: TimerSheetDestination?

    // MARK: - TimerRouterProtocol

    func navigateToCreateTimer() {
        sheetDestination = .createTimer
    }
}

// MARK: - Destination Types

enum TimerSheetDestination: Identifiable {
    case createTimer

    var id: String {
        switch self {
        case .createTimer: return "createTimer"
        }
    }
}
