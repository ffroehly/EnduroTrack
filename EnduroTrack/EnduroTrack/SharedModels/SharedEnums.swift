//
//  SharedEnums.swift
//  EnduroTrack
//

import Foundation
import Domain

/// Enums and value objects shared across multiple features.
/// Business-level enums (e.g. DifficultyLevel) live in the Domain package.
/// Only app-layer, UI-facing enums that don't belong to Domain live here.

/// Unit system preferred by the user.
enum UnitSystem: String, CaseIterable, Equatable, Sendable {
    case metric   = "Metric"
    case imperial = "Imperial"
}
