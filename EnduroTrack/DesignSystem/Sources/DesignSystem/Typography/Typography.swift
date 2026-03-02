//
//  Typography.swift
//  DesignSystem
//

import SwiftUI

/// Centralised typography scale for EnduroTrack.
///
/// Usage:  `.font(ETFont.title)`
public enum ETFont {

    // MARK: - Scale
    public static let largeTitle  = Font.largeTitle.bold()
    public static let title       = Font.title.bold()
    public static let title2      = Font.title2.bold()
    public static let headline    = Font.headline
    public static let body        = Font.body
    public static let callout     = Font.callout
    public static let caption     = Font.caption
    public static let caption2    = Font.caption2

    // MARK: - Monospaced (used in Timer feature)
    public static func timer(size: CGFloat = 72) -> Font {
        .system(size: size, weight: .thin, design: .monospaced)
    }
}

/// View modifier that applies the DesignSystem font + colour.
public struct ETTextStyle: ViewModifier {
    let font: Font
    let color: Color

    public func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
    }
}

public extension View {
    func etTextStyle(_ font: Font, color: Color = .primary) -> some View {
        modifier(ETTextStyle(font: font, color: color))
    }
}
