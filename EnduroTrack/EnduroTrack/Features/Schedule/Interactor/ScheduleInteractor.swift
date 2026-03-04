// ScheduleInteractor.swift
// EnduroTrack › Features › Schedule

import Foundation
import Domain

final class ScheduleInteractor: ScheduleInteractorProtocol {

    private let fetchSchedulesUseCase: FetchSchedulesUseCaseProtocol
    private let createScheduleUseCase: CreateScheduleUseCaseProtocol
    private let updateScheduleUseCase: UpdateScheduleUseCaseProtocol
    private let deleteScheduleUseCase: DeleteScheduleUseCaseProtocol
    private let fetchExercisesUseCase: FetchExercisesUseCaseProtocol

    init(
        fetchSchedulesUseCase: FetchSchedulesUseCaseProtocol,
        createScheduleUseCase: CreateScheduleUseCaseProtocol,
        updateScheduleUseCase: UpdateScheduleUseCaseProtocol,
        deleteScheduleUseCase: DeleteScheduleUseCaseProtocol,
        fetchExercisesUseCase: FetchExercisesUseCaseProtocol
    ) {
        self.fetchSchedulesUseCase = fetchSchedulesUseCase
        self.createScheduleUseCase = createScheduleUseCase
        self.updateScheduleUseCase = updateScheduleUseCase
        self.deleteScheduleUseCase = deleteScheduleUseCase
        self.fetchExercisesUseCase = fetchExercisesUseCase
    }

    func fetchSchedules() async throws -> [Schedule] {
        try await fetchSchedulesUseCase.fetchAll()
    }

    func fetchExercises() async throws -> [Exercise] {
        try await fetchExercisesUseCase.fetchAll()
    }

    func createSchedule(exerciseId: UUID, daySchedules: [DaySchedule]) async throws -> Schedule {
        let schedule = Schedule(exerciseId: exerciseId, daySchedules: daySchedules)
        return try await createScheduleUseCase.create(schedule: schedule)
    }

    func updateSchedule(_ schedule: Schedule) async throws -> Schedule {
        try await updateScheduleUseCase.update(schedule: schedule)
    }

    func deleteSchedule(id: UUID) async throws {
        try await deleteScheduleUseCase.delete(scheduleID: id)
    }
}
