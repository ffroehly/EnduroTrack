// ScheduleService.swift
// EnduroTrack › Data › Services

import Foundation
import Domain

/// Implements schedule use cases by delegating to ScheduleRepositoryProtocol.
final class ScheduleService:
    FetchSchedulesUseCaseProtocol,
    CreateScheduleUseCaseProtocol,
    UpdateScheduleUseCaseProtocol,
    DeleteScheduleUseCaseProtocol {

    private let repository: ScheduleRepositoryProtocol

    init(repository: ScheduleRepositoryProtocol) {
        self.repository = repository
    }

    func fetchAll() async throws -> [Schedule] {
        try await repository.fetchAll()
    }

    func create(schedule: Schedule) async throws -> Schedule {
        try await repository.save(schedule)
    }

    func update(schedule: Schedule) async throws -> Schedule {
        try await repository.update(schedule)
    }

    func delete(scheduleID: UUID) async throws {
        try await repository.delete(id: scheduleID)
    }
}
