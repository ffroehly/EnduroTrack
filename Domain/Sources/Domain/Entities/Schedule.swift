// Schedule.swift
// Domain
//
// Entity representing a weekly exercise schedule.

import Foundation

/// Day of the week enum for scheduling.
public enum DayOfWeek: Int, CaseIterable, Equatable, Hashable, Sendable, Codable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    public var displayName: String {
        switch self {
        case .sunday:    return "Sunday"
        case .monday:    return "Monday"
        case .tuesday:   return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday:  return "Thursday"
        case .friday:    return "Friday"
        case .saturday:  return "Saturday"
        }
    }

    public var shortName: String {
        String(displayName.prefix(3))
    }

    /// Returns the Calendar weekday integer (1=Sunday, 2=Monday, ... 7=Saturday).
    public var calendarWeekday: Int { rawValue }
}

/// Represents a specific day + reminder time within a schedule.
public struct DaySchedule: Equatable, Hashable, Sendable, Codable {
    public let dayOfWeek: DayOfWeek
    /// Hour of day (0–23) for the reminder.
    public let reminderHour: Int
    /// Minute (0–59) for the reminder.
    public let reminderMinute: Int

    public init(dayOfWeek: DayOfWeek, reminderHour: Int, reminderMinute: Int) {
        self.dayOfWeek = dayOfWeek
        self.reminderHour = reminderHour
        self.reminderMinute = reminderMinute
    }

    public var reminderTimeFormatted: String {
        String(format: "%02d:%02d", reminderHour, reminderMinute)
    }
}

/// Represents a recurring weekly schedule linking an exercise to one or more days.
public struct Schedule: Identifiable, Equatable, Sendable, Codable {

    public let id: UUID
    /// The ID of the exercise this schedule references.
    public let exerciseId: UUID
    /// List of days (with reminder times) when this exercise should be performed.
    public let daySchedules: [DaySchedule]
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        exerciseId: UUID,
        daySchedules: [DaySchedule] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.daySchedules = daySchedules
        self.createdAt = createdAt
    }
}
