// RunningContracts.swift (Schedule feature)
// EnduroTrack › Features › Running (Schedule)

import Foundation
import Domain

@MainActor
protocol ScheduleViewProtocol: AnyObject {
    func render(state: ScheduleViewState)
}

@MainActor
protocol SchedulePresenterProtocol: AnyObject {
    func viewDidAppear() async
    func didTapAddSchedule()
    func didTapDeleteSchedule(id: UUID)
    func didTapEditSchedule(_ schedule: Schedule)
    func didSaveNewSchedule(exerciseId: UUID, daySchedules: [DaySchedule])
    func didSaveEditedSchedule(_ schedule: Schedule, exerciseId: UUID, daySchedules: [DaySchedule])
}

protocol ScheduleInteractorProtocol: AnyObject {
    func fetchSchedules() async throws -> [Schedule]
    func fetchExercises() async throws -> [Exercise]
    func createSchedule(exerciseId: UUID, daySchedules: [DaySchedule]) async throws -> Schedule
    func updateSchedule(_ schedule: Schedule) async throws -> Schedule
    func deleteSchedule(id: UUID) async throws
}

@MainActor
protocol ScheduleRouterProtocol: AnyObject {}

/// View model combining a Schedule with its exercise name for display.
struct ScheduleViewModel: Equatable, Identifiable {
    let id: UUID
    let schedule: Schedule
    let exerciseTitle: String
}

enum ScheduleViewState: Equatable {
    case loading
    case list(schedules: [ScheduleViewModel], exercises: [Exercise])
    case empty(exercises: [Exercise])
    case showingCreateForm(exercises: [Exercise])
    case showingEditForm(schedule: Schedule, exercises: [Exercise])
    case error(message: String)
}
