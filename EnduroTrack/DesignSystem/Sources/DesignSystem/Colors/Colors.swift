//
//  Colors.swift
//  DesignSystem
//

import SwiftUI

/// Centralised colour palette for EnduroTrack.
///
/// Usage:  `.foregroundStyle(ETColor.primary)`
///
/// TODO: Create a `Colors.xcassets` inside the DesignSystem package and define
/// the named colour assets below to replace the fallback values.
public enum ETColor {

    // MARK: - Brand
    /// Primary brand colour – used for CTAs and key actions.
    /// Replace the fallback with `Color("ETColorPrimary", bundle: .module)` once
    /// the asset catalogue is added to the DesignSystem package.
    public static let primary: Color = .blue

    /// Secondary brand colour – used for accents and highlights.
    public static let secondary: Color = .indigo

    // MARK: - Semantic
    /// Background colour for cards and elevated surfaces.
    public static let surface: Color = Color(.systemBackground)

    /// Standard text colour.
    public static let textPrimary: Color = Color(.label)

    /// Muted / caption text colour.
    public static let textSecondary: Color = Color(.secondaryLabel)

    // MARK: - Status
    public static let success: Color = .green
    public static let warning: Color = .orange
    public static let error:   Color = .red

    // MARK: - Convenience alias (used by components)
    public static let primaryFallback: Color = primary
}
