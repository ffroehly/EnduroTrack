// PrimaryButton.swift
// DesignSystem
//
// A reusable primary action button following the app's design language.
// All features use this component instead of creating ad-hoc buttons.

import SwiftUI

/// The style variant for a PrimaryButton.
public enum PrimaryButtonStyle {
    case filled
    case outlined
}

/// A reusable primary action button.
///
/// Usage:
/// ```swift
/// PrimaryButton(title: "Start Workout", style: .filled) {
///     presenter.didTapStart()
/// }
/// ```
public struct PrimaryButton: View {

    // MARK: - Properties

    private let title: String
    private let style: PrimaryButtonStyle
    private let isLoading: Bool
    private let action: () -> Void

    // MARK: - Init

    public init(
        title: String,
        style: PrimaryButtonStyle = .filled,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: labelColor))
                } else {
                    Text(title)
                        .font(AppFonts.headlineMedium)
                        .foregroundStyle(labelColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(AppColors.primary, lineWidth: style == .outlined ? 2 : 0)
            )
        }
        .disabled(isLoading)
    }

    // MARK: - Private Helpers

    private var background: some View {
        Group {
            if style == .filled {
                AppColors.primary
            } else {
                Color.clear
            }
        }
    }

    private var labelColor: Color {
        style == .filled ? .white : AppColors.primary
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Start Workout", style: .filled) {}
        PrimaryButton(title: "View History", style: .outlined) {}
        PrimaryButton(title: "Loading...", style: .filled, isLoading: true) {}
    }
    .padding()
}
