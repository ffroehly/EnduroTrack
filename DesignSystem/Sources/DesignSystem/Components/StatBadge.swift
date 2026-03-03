// StatBadge.swift
// DesignSystem
//
// A reusable badge component for displaying a single metric (label + value).
// Used in workout summaries, run stats, and timer overviews.

import SwiftUI

/// Displays a single stat with a label and value pair.
///
/// Usage:
/// ```swift
/// StatBadge(label: "Distance", value: "5.2 km")
/// StatBadge(label: "Duration", value: "28:04", icon: "clock")
/// ```
public struct StatBadge: View {

    // MARK: - Properties

    private let label: String
    private let value: String
    private let icon: String?

    // MARK: - Init

    public init(label: String, value: String, icon: String? = nil) {
        self.label = label
        self.value = value
        self.icon = icon
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            Text(value)
                .font(AppFonts.statValue)
                .foregroundStyle(AppColors.textPrimary)
            Text(label)
                .font(AppFonts.labelSmall)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}

#Preview {
    HStack(spacing: 24) {
        StatBadge(label: "Distance", value: "5.2 km", icon: "figure.run")
        StatBadge(label: "Duration", value: "28:04", icon: "clock")
        StatBadge(label: "Pace", value: "5:23", icon: "speedometer")
    }
    .padding()
}
