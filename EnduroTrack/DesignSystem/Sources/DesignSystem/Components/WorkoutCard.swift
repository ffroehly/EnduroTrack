//
//  WorkoutCard.swift
//  DesignSystem
//

import SwiftUI

/// A card component that previews a single workout.
///
/// Accepts plain string / numeric parameters so the DesignSystem does NOT
/// depend on the Domain package (Dependency Inversion Principle).
///
/// Usage:
/// ```swift
/// WorkoutCard(
///     name: workout.name,
///     duration: workout.duration.formatted,
///     difficulty: workout.difficulty.rawValue
/// )
/// ```
public struct WorkoutCard: View {
    let name: String
    let duration: String
    let difficulty: String

    public init(name: String, duration: String, difficulty: String) {
        self.name = name
        self.duration = duration
        self.difficulty = difficulty
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(ETFont.headline)

            HStack {
                Label(duration, systemImage: "clock")
                Spacer()
                Text(difficulty)
                    .font(ETFont.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ETColor.primaryFallback.opacity(0.15))
                    .clipShape(Capsule())
            }
            .font(ETFont.callout)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(ETColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

#Preview {
    WorkoutCard(
        name: "Morning Strength",
        duration: "45m 00s",
        difficulty: "Medium"
    )
    .padding()
}
