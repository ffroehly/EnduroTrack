// ScheduleUseCaseProtocols.swift
// Domain

import Foundation

public protocol FetchSchedulesUseCaseProtocol: Sendable {
    func fetchAll() async throws -> [Schedule]
}

public protocol CreateScheduleUseCaseProtocol: Sendable {
    func create(schedule: Schedule) async throws -> Schedule
}

public protocol UpdateScheduleUseCaseProtocol: Sendable {
    func update(schedule: Schedule) async throws -> Schedule
}

public protocol DeleteScheduleUseCaseProtocol: Sendable {
    func delete(scheduleID: UUID) async throws
}
