// DomainTests.swift
// DomainTests

import XCTest
@testable import Domain

final class DomainTests: XCTestCase {

    // MARK: - Workout Entity Tests

    func testWorkoutEntityCreation() {
        let workout = Workout(
            title: "Morning Strength",
            type: .strength,
            status: .planned,
            startedAt: Date(),
            durationSeconds: 3600
        )
        XCTAssertFalse(workout.id.uuidString.isEmpty)
        XCTAssertEqual(workout.title, "Morning Strength")
        XCTAssertEqual(workout.type, .strength)
        XCTAssertEqual(workout.status, .planned)
        XCTAssertEqual(workout.durationSeconds, 3600)
        XCTAssertTrue(workout.exercises.isEmpty)
    }

    // MARK: - Exercise Entity Tests

    func testExerciseEntityCreation() {
        let exercise = Exercise(
            title: "Tabata",
            warmupSeconds: 5,
            activeSeconds: 20,
            restSeconds: 10,
            repetitions: 8
        )
        XCTAssertFalse(exercise.id.uuidString.isEmpty)
        XCTAssertEqual(exercise.title, "Tabata")
        XCTAssertEqual(exercise.warmupSeconds, 5)
        XCTAssertEqual(exercise.activeSeconds, 20)
        XCTAssertEqual(exercise.restSeconds, 10)
        XCTAssertEqual(exercise.repetitions, 8)
        XCTAssertNil(exercise.recoverySeconds)
    }

    func testExerciseTotalDuration() {
        let exercise = Exercise(
            title: "Test",
            warmupSeconds: 5,
            activeSeconds: 30,
            restSeconds: 10,
            repetitions: 4,
            recoverySeconds: 60
        )
        // 5 + (30 + 10) * 4 + 60 = 5 + 160 + 60 = 225
        XCTAssertEqual(exercise.totalDurationSeconds, 225)
    }

    // MARK: - Schedule Entity Tests

    func testScheduleEntityCreation() {
        let exerciseId = UUID()
        let daySchedule = DaySchedule(dayOfWeek: .monday, reminderHour: 8, reminderMinute: 0)
        let schedule = Schedule(exerciseId: exerciseId, daySchedules: [daySchedule])
        XCTAssertFalse(schedule.id.uuidString.isEmpty)
        XCTAssertEqual(schedule.exerciseId, exerciseId)
        XCTAssertEqual(schedule.daySchedules.count, 1)
        XCTAssertEqual(schedule.daySchedules[0].dayOfWeek, .monday)
        XCTAssertEqual(schedule.daySchedules[0].reminderTimeFormatted, "08:00")
    }

    // MARK: - ExerciseSession Entity Tests

    func testExerciseSessionCreation() {
        let exerciseId = UUID()
        let session = ExerciseSession(
            exerciseId: exerciseId,
            exerciseTitle: "Tabata",
            durationSeconds: 225
        )
        XCTAssertFalse(session.id.uuidString.isEmpty)
        XCTAssertEqual(session.exerciseId, exerciseId)
        XCTAssertEqual(session.exerciseTitle, "Tabata")
        XCTAssertEqual(session.durationSeconds, 225)
    }

    // MARK: - WorkoutType Enum Tests

    func testWorkoutTypeDisplayNames() {
        XCTAssertEqual(WorkoutType.strength.displayName, "Strength")
        XCTAssertEqual(WorkoutType.running.displayName, "Running")
        XCTAssertEqual(WorkoutType.hiit.displayName, "HIIT")
    }

    // MARK: - WorkoutStatus Enum Tests

    func testWorkoutStatusDisplayNames() {
        XCTAssertEqual(WorkoutStatus.planned.displayName, "Planned")
        XCTAssertEqual(WorkoutStatus.inProgress.displayName, "In Progress")
        XCTAssertEqual(WorkoutStatus.completed.displayName, "Completed")
    }

    // MARK: - DayOfWeek Tests

    func testDayOfWeekDisplayNames() {
        XCTAssertEqual(DayOfWeek.monday.displayName, "Monday")
        XCTAssertEqual(DayOfWeek.monday.shortName, "Mon")
        XCTAssertEqual(DayOfWeek.sunday.calendarWeekday, 1)
        XCTAssertEqual(DayOfWeek.monday.calendarWeekday, 2)
    }
}
