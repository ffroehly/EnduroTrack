//
//  Distance.swift
//  Domain
//

import Foundation

/// Value object representing a physical distance.
///
/// Always stored internally in metres; conversion helpers are provided.
public struct Distance: Equatable, Hashable, Sendable {

    /// Distance in metres.
    public let metres: Double

    public init(metres: Double) {
        precondition(metres >= 0, "Distance must be non-negative.")
        self.metres = metres
    }

    // MARK: - Convenience initialisers
    public static func kilometres(_ km: Double) -> Distance { Distance(metres: km * 1_000) }
    public static func miles(_ mi: Double) -> Distance      { Distance(metres: mi * 1_609.344) }

    // MARK: - Conversions
    public var kilometres: Double { metres / 1_000 }
    public var miles: Double      { metres / 1_609.344 }

    /// Human-readable km string (e.g. "5.00 km").
    public var formattedKm: String { String(format: "%.2f km", kilometres) }
}
