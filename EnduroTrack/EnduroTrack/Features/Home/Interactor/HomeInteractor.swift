// HomeInteractor.swift
// EnduroTrack › Features › Home

import Foundation
import Domain

final class HomeInteractor: HomeInteractorProtocol {

    private let fetchSchedulesUseCase: FetchSchedulesUseCaseProtocol
    private let fetchExercisesUseCase: FetchExercisesUseCaseProtocol
    private let fetchSessionsUseCase: FetchExerciseSessionsUseCaseProtocol

    init(
        fetchSchedulesUseCase: FetchSchedulesUseCaseProtocol,
        fetchExercisesUseCase: FetchExercisesUseCaseProtocol,
        fetchSessionsUseCase: FetchExerciseSessionsUseCaseProtocol
    ) {
        self.fetchSchedulesUseCase = fetchSchedulesUseCase
        self.fetchExercisesUseCase = fetchExercisesUseCase
        self.fetchSessionsUseCase = fetchSessionsUseCase
    }

    func fetchNextScheduledExercise() async throws -> NextExerciseInfo? {
        async let schedulesTask = fetchSchedulesUseCase.fetchAll()
        async let exercisesTask = fetchExercisesUseCase.fetchAll()
        let (schedules, exercises) = try await (schedulesTask, exercisesTask)
        let exerciseMap = Dictionary(uniqueKeysWithValues: exercises.map { ($0.id, $0) })

        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())

        var candidates: [(exercise: Exercise, daySchedule: DaySchedule, daysFromNow: Int)] = []
        for schedule in schedules {
            guard let exercise = exerciseMap[schedule.exerciseId] else { continue }
            for daySchedule in schedule.daySchedules {
                let targetWeekday = daySchedule.dayOfWeek.calendarWeekday
                var daysFromNow = targetWeekday - today
                if daysFromNow < 0 { daysFromNow += 7 }
                if daysFromNow == 0 {
                    let now = Date()
                    let nowHour = calendar.component(.hour, from: now)
                    let nowMinute = calendar.component(.minute, from: now)
                    let reminderMinutes = daySchedule.reminderHour * 60 + daySchedule.reminderMinute
                    let nowMinutes = nowHour * 60 + nowMinute
                    if reminderMinutes <= nowMinutes {
                        daysFromNow = 7
                    }
                }
                candidates.append((exercise, daySchedule, daysFromNow))
            }
        }

        guard let best = candidates.sorted(by: {
            if $0.daysFromNow != $1.daysFromNow { return $0.daysFromNow < $1.daysFromNow }
            let t0 = $0.daySchedule.reminderHour * 60 + $0.daySchedule.reminderMinute
            let t1 = $1.daySchedule.reminderHour * 60 + $1.daySchedule.reminderMinute
            return t0 < t1
        }).first else {
            return nil
        }

        return NextExerciseInfo(
            exerciseId: best.exercise.id,
            exerciseTitle: best.exercise.title,
            dayOfWeek: best.daySchedule.dayOfWeek,
            reminderTimeFormatted: best.daySchedule.reminderTimeFormatted,
            isToday: best.daysFromNow == 0
        )
    }

    func fetchAllSessions() async throws -> [ExerciseSession] {
        let all = try await fetchSessionsUseCase.fetchAll()
        return all
    }
}
