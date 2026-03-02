//
//  AgentConfig.swift
//  EnduroTrack
//

import Foundation

/// Agent-level configuration for EnduroTrack.
///
/// Use this file to:
///  - Declare feature flags that control which features are enabled.
///  - Store agent command identifiers for AI-assisted workflows.
///  - Centralise environment-level settings (API base URLs, timeouts …).
///
/// Example usage (to be expanded as the project grows):
///
///     if AgentConfig.isHomeFeatureEnabled {
///         // render HomeView
///     }
enum AgentConfig {

    // MARK: - Feature Flags
    /// Controls whether the Home feature tab is shown.
    static let isHomeFeatureEnabled: Bool = true

    /// Controls whether the Workout feature tab is shown.
    static let isWorkoutFeatureEnabled: Bool = true

    /// Controls whether the Running feature tab is shown.
    static let isRunningFeatureEnabled: Bool = true

    /// Controls whether the Timer feature tab is shown.
    static let isTimerFeatureEnabled: Bool = true

    // MARK: - API
    /// Base URL for the remote API (replace before shipping).
    static let apiBaseURL: String = "https://api.endurotrack.example.com/v1"

    /// Network request timeout in seconds.
    static let networkTimeoutSeconds: Double = 30.0

    // MARK: - AI Agent Commands
    /// Identifier used by AI agents when scaffolding a new feature.
    static let commandAddFeature: String = "add-feature"

    /// Identifier used by AI agents when generating a use case.
    static let commandAddUseCase: String = "add-use-case"
}
