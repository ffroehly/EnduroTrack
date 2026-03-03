// Card.swift
// DesignSystem
//
// A reusable card container component used across all features.
// Provides consistent elevation, padding, and corner radius.

import SwiftUI

/// A reusable card container that wraps content in a styled surface.
///
/// Usage:
/// ```swift
/// Card {
///     VStack {
///         Text("Workout Title")
///         Text("45 min")
///     }
/// }
/// ```
public struct Card<Content: View>: View {

    // MARK: - Properties

    private let content: Content

    // MARK: - Init

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        content
            .padding(16)
            .background(AppColors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    Card {
        VStack(alignment: .leading, spacing: 8) {
            Text("Morning Run")
                .font(AppFonts.headlineMedium)
            Text("5.2 km · 28 min")
                .font(AppFonts.bodyMedium)
        }
    }
    .padding()
}
