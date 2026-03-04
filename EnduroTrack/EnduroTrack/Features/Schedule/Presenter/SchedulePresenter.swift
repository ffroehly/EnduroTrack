// SchedulePresenter.swift
// EnduroTrack › Features › Schedule

import Foundation
import Domain
import Combine

@MainActor
final class SchedulePresenter: ObservableObject, SchedulePresenterProtocol {

    @Published private(set) var state: ScheduleViewState = .loading

    private let interactor: ScheduleInteractorProtocol
    private let router: ScheduleRouterProtocol

    init(interactor: ScheduleInteractorProtocol, router: ScheduleRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidAppear() async {
        await loadData()
    }

    private func loadData() async {
        state = .loading
        do {
            async let schedules = interactor.fetchSchedules()
            async let exercises = interactor.fetchExercises()
            let (s, e) = try await (schedules, exercises)
            let exerciseMap = Dictionary(uniqueKeysWithValues: e.map { ($0.id, $0.title) })
            let viewModels = s.map { schedule in
                ScheduleViewModel(
                    id: schedule.id,
                    schedule: schedule,
                    exerciseTitle: exerciseMap[schedule.exerciseId] ?? "Unknown Exercise"
                )
            }
            if viewModels.isEmpty {
                state = .empty(exercises: e)
            } else {
                state = .list(schedules: viewModels, exercises: e)
            }
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    func didTapAddSchedule() {
        Task {
            let exercises = (try? await interactor.fetchExercises()) ?? []
            state = .showingCreateForm(exercises: exercises)
        }
    }

    func didTapDeleteSchedule(id: UUID) {
        Task {
            do {
                try await interactor.deleteSchedule(id: id)
                await loadData()
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didTapEditSchedule(_ schedule: Schedule) {
        Task {
            let exercises = (try? await interactor.fetchExercises()) ?? []
            state = .showingEditForm(schedule: schedule, exercises: exercises)
        }
    }

    func didSaveNewSchedule(exerciseId: UUID, daySchedules: [DaySchedule]) {
        Task {
            do {
                _ = try await interactor.createSchedule(exerciseId: exerciseId, daySchedules: daySchedules)
                await loadData()
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }

    func didSaveEditedSchedule(_ schedule: Schedule, exerciseId: UUID, daySchedules: [DaySchedule]) {
        Task {
            do {
                let updated = Schedule(id: schedule.id, exerciseId: exerciseId, daySchedules: daySchedules, createdAt: schedule.createdAt)
                _ = try await interactor.updateSchedule(updated)
                await loadData()
            } catch {
                state = .error(message: error.localizedDescription)
            }
        }
    }
}
