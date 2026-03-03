// SharedEnums.swift
// EnduroTrack › SharedModels

import Foundation

/// Represents the active tab in the main tab bar.
enum AppTab: CaseIterable, Identifiable {
    case home
    case exercises
    case schedule
    case history

    var id: Self { self }

    var title: String {
        switch self {
        case .home:      return "Home"
        case .exercises: return "Exercises"
        case .schedule:  return "Schedule"
        case .history:   return "History"
        }
    }

    var systemImage: String {
        switch self {
        case .home:      return "house.fill"
        case .exercises: return "figure.strengthtraining.traditional"
        case .schedule:  return "calendar"
        case .history:   return "clock.arrow.circlepath"
        }
    }
}
