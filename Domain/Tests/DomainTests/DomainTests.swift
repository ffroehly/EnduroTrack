// DomainTests.swift
// DomainTests
//
// Placeholder test file. Add unit tests for Domain entities and use cases here.
// Domain tests should be pure Swift — no UI, no network, no mocking of frameworks.

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

    // MARK: - RunSession Entity Tests

    func testRunSessionEntityCreation() {
        let session = RunSession(
            startedAt: Date(),
            distanceMeters: 5000,
            durationSeconds: 1800
        )

        XCTAssertFalse(session.id.uuidString.isEmpty)
        XCTAssertEqual(session.distanceMeters, 5000)
        XCTAssertEqual(session.durationSeconds, 1800)
        XCTAssertTrue(session.route.isEmpty)
    }

    // MARK: - TimerSession Entity Tests

    func testTimerSessionEntityCreation() {
        let interval = TimerInterval(type: .work, durationSeconds: 30)
        let session = TimerSession(
            name: "Tabata",
            intervals: [interval],
            repeatCount: 8
        )

        XCTAssertFalse(session.id.uuidString.isEmpty)
        XCTAssertEqual(session.name, "Tabata")
        XCTAssertEqual(session.intervals.count, 1)
        XCTAssertEqual(session.repeatCount, 8)
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
}
