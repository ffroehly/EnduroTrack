// WorkoutStatus.swift
// Domain
//
// Enum defining the lifecycle status of a workout session.

/// The lifecycle state of a workout session.
/// This is a Domain enum — no framework dependencies.
public enum WorkoutStatus: String, CaseIterable, Equatable, Sendable {
    case planned
    case inProgress
    case completed
    case cancelled

    /// A human-readable display name for each status.
    public var displayName: String {
        switch self {
        case .planned:    return "Planned"
        case .inProgress: return "In Progress"
        case .completed:  return "Completed"
        case .cancelled:  return "Cancelled"
        }
    }
}
