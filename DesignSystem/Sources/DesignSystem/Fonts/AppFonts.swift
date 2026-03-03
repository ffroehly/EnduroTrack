// AppFonts.swift
// DesignSystem
//
// Typography system for EnduroTrack.
// All features use these text styles — never define font sizes directly in feature code.

import SwiftUI

/// The typography system for EnduroTrack.
/// Provides semantic text styles that map to the app's design language.
public enum AppFonts {

    // MARK: - Display

    /// Large hero text, used for screen titles and stats.
    public static let displayLarge = Font.system(size: 34, weight: .bold, design: .rounded)

    /// Medium hero text.
    public static let displayMedium = Font.system(size: 28, weight: .bold, design: .rounded)

    // MARK: - Headline

    /// Section headers and card titles.
    public static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .rounded)

    /// Sub-section headers.
    public static let headlineMedium = Font.system(size: 18, weight: .semibold, design: .rounded)

    // MARK: - Body

    /// Primary readable body text.
    public static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)

    /// Secondary body text.
    public static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: - Label

    /// Small labels, captions, and metadata.
    public static let labelSmall = Font.system(size: 12, weight: .medium, design: .default)

    // MARK: - Monospaced (for timers and stats)

    /// Monospaced font for timer displays.
    public static let timerDisplay = Font.system(size: 48, weight: .bold, design: .monospaced)

    /// Monospaced font for smaller stats.
    public static let statValue = Font.system(size: 24, weight: .semibold, design: .monospaced)
}
