//
//  PrimaryButton.swift
//  DesignSystem
//

import SwiftUI

/// A branded primary button.
///
/// Usage:
/// ```swift
/// PrimaryButton(title: "Start Workout") {
///     store.send(.startTapped)
/// }
/// ```
public struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false

    public init(title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(title)
                        .font(ETFont.headline)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .background(ETColor.primaryFallback)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Start Workout") {}
        PrimaryButton(title: "Loading…", isLoading: true) {}
    }
    .padding()
}
