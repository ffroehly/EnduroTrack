// WorkoutType.swift
// Domain
//
// Enum defining the different types of workouts supported by the app.

/// The category of a workout session.
/// This is a Domain enum — no framework dependencies.
public enum WorkoutType: String, CaseIterable, Equatable, Sendable {
    case strength
    case cardio
    case hiit
    case yoga
    case mobility
    case running
    case cycling
    case swimming
    case custom

    /// A human-readable display name for each type.
    public var displayName: String {
        switch self {
        case .strength:  return "Strength"
        case .cardio:    return "Cardio"
        case .hiit:      return "HIIT"
        case .yoga:      return "Yoga"
        case .mobility:  return "Mobility"
        case .running:   return "Running"
        case .cycling:   return "Cycling"
        case .swimming:  return "Swimming"
        case .custom:    return "Custom"
        }
    }
}
