// ScheduleRepositoryProtocol.swift
// Domain

import Foundation

public protocol ScheduleRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [Schedule]
    func save(_ schedule: Schedule) async throws -> Schedule
    func update(_ schedule: Schedule) async throws -> Schedule
    func delete(id: UUID) async throws
}
