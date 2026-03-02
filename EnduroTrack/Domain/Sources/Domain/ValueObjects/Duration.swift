//
//  Duration.swift
//  Domain
//

import Foundation

/// Value object representing an elapsed time duration.
///
/// Value object – no identity; two Durations with the same seconds are equal.
public struct Duration: Equatable, Hashable, Sendable {

    /// Duration expressed in seconds.
    public let seconds: Int

    public init(seconds: Int) {
        precondition(seconds >= 0, "Duration must be non-negative.")
        self.seconds = seconds
    }

    // MARK: - Convenience initialisers
    public static func minutes(_ m: Int) -> Duration { Duration(seconds: m * 60) }
    public static func hours(_ h: Int) -> Duration   { Duration(seconds: h * 3600) }

    // MARK: - Derived properties
    public var minutes: Int { seconds / 60 }
    public var hours: Int   { seconds / 3600 }

    /// Human-readable string, e.g. "1h 30m 05s".
    public var formatted: String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        if h > 0 { return String(format: "%dh %02dm %02ds", h, m, s) }
        if m > 0 { return String(format: "%dm %02ds", m, s) }
        return String(format: "%ds", s)
    }
}
