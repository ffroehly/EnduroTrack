// AppColors.swift
// DesignSystem
//
// Centralized color palette for the EnduroTrack app.
// All feature UIs use these tokens — never hard-coded hex values in feature code.
// Update this file when brand colors change; all features update automatically.

import SwiftUI

/// The centralized color palette for EnduroTrack.
/// Use these semantic tokens throughout the app for consistent theming.
public enum AppColors {

    // MARK: - Brand

    /// Primary brand color — used for CTAs, highlights, and key actions.
    public static let primary = Color("Primary", bundle: .module)

    /// Secondary brand color — used for accents and secondary actions.
    public static let secondary = Color("Secondary", bundle: .module)

    // MARK: - Background

    /// Default background for screens.
    public static let backgroundPrimary = Color("BackgroundPrimary", bundle: .module)

    /// Card / surface background.
    public static let backgroundSecondary = Color("BackgroundSecondary", bundle: .module)

    // MARK: - Text

    /// Primary text color.
    public static let textPrimary = Color("TextPrimary", bundle: .module)

    /// Secondary / muted text color.
    public static let textSecondary = Color("TextSecondary", bundle: .module)

    // MARK: - Status

    /// Success state color (e.g. completed workout).
    public static let success = Color("Success", bundle: .module)

    /// Warning state color.
    public static let warning = Color("Warning", bundle: .module)

    /// Error / destructive state color.
    public static let error = Color("Error", bundle: .module)

    // MARK: - Workout Types

    /// Accent color for strength workouts.
    public static let strengthAccent = Color("StrengthAccent", bundle: .module)

    /// Accent color for cardio workouts.
    public static let cardioAccent = Color("CardioAccent", bundle: .module)

    /// Accent color for running sessions.
    public static let runningAccent = Color("RunningAccent", bundle: .module)
}
