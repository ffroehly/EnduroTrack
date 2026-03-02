//
//  DifficultyLevel.swift
//  Domain
//

/// Difficulty level for a training session.
/// Defined here (Domain layer) as the single source of truth.
public enum DifficultyLevel: String, CaseIterable, Equatable, Sendable {
    case easy    = "Easy"
    case medium  = "Medium"
    case hard    = "Hard"
    case extreme = "Extreme"
}
