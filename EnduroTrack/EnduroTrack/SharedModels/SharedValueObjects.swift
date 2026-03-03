// SharedValueObjects.swift
// EnduroTrack › SharedModels
//
// Value objects shared across multiple features.
// Add app-level value types here that span feature boundaries.

import Foundation

/// A simple wrapper for a formatted duration string used across UI layers.
struct FormattedDuration: Equatable {

    let totalSeconds: Int

    /// Returns a "MM:SS" formatted string for display.
    var display: String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Returns a long-form description, e.g. "1h 23m" or "45s" for short durations.
    var longDisplay: String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
}
