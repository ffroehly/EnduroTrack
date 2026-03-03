// SharedEnums.swift
// EnduroTrack › SharedModels
//
// Enums and value types shared across multiple features (but not in the Domain layer).
// These are app-level concerns — not pure business logic, but not feature-specific either.

import Foundation

/// Represents the active tab in the main tab bar.
enum AppTab: CaseIterable, Identifiable {
    case home
    case workout
    case running
    case timer

    var id: Self { self }

    var title: String {
        switch self {
        case .home:    return "Home"
        case .workout: return "Workout"
        case .running: return "Running"
        case .timer:   return "Timer"
        }
    }

    var systemImage: String {
        switch self {
        case .home:    return "house.fill"
        case .workout: return "dumbbell.fill"
        case .running: return "figure.run"
        case .timer:   return "timer"
        }
    }
}
