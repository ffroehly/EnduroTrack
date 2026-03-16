// ScheduleInteractorTests.swift
// EnduroTrackTests
//
// Unit tests for ScheduleInteractor.
// Dependencies are injected via protocols (Dependency Inversion).
// Each test class is responsible for one component (Single Responsibility).

import XCTest
import Domain
@testable import EnduroTrack

final class ScheduleInteractorTests: XCTestCase {

    // MARK: - Properties

    private var fetchSchedulesUseCase: MockFetchSchedulesUseCase!
    private var createScheduleUseCase: MockCreateScheduleUseCase!
    private var updateScheduleUseCase: MockUpdateScheduleUseCase!
    private var deleteScheduleUseCase: MockDeleteScheduleUseCase!
    private var fetchExercisesUseCase: MockFetchExercisesUseCase!
    private var sut: ScheduleInteractor!

    // MARK: - setUp / tearDown

    override func setUp() {
        super.setUp()
        fetchSchedulesUseCase = MockFetchSchedulesUseCase()
        createScheduleUseCase = MockCreateScheduleUseCase()
        updateScheduleUseCase = MockUpdateScheduleUseCase()
        deleteScheduleUseCase = MockDeleteScheduleUseCase()
        fetchExercisesUseCase = MockFetchExercisesUseCase()
        sut = ScheduleInteractor(
            fetchSchedulesUseCase: fetchSchedulesUseCase,
            createScheduleUseCase: createScheduleUseCase,
            updateScheduleUseCase: updateScheduleUseCase,
            deleteScheduleUseCase: deleteScheduleUseCase,
            fetchExercisesUseCase: fetchExercisesUseCase
        )
    }

    override func tearDown() {
        sut = nil
        fetchSchedulesUseCase = nil
        createScheduleUseCase = nil
        updateScheduleUseCase = nil
        deleteScheduleUseCase = nil
        fetchExercisesUseCase = nil
        super.tearDown()
    }

    // MARK: - fetchSchedules

    func testFetchSchedulesReturnsStubbedSchedules() async throws {
        let exerciseId = UUID()
        let daySchedule = DaySchedule(dayOfWeek: .monday, reminderHour: 8, reminderMinute: 0)
        let expected = [Schedule(exerciseId: exerciseId, daySchedules: [daySchedule])]
        fetchSchedulesUseCase.stubbedSchedules = expected
        let result = try await sut.fetchSchedules()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].exerciseId, exerciseId)
    }

    func testFetchSchedulesReturnsEmptyArray() async throws {
        fetchSchedulesUseCase.stubbedSchedules = []
        let result = try await sut.fetchSchedules()
        XCTAssertTrue(result.isEmpty)
    }

    func testFetchSchedulesRethrowsError() async {
        fetchSchedulesUseCase.shouldThrow = true
        do {
            _ = try await sut.fetchSchedules()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - fetchExercises

    func testFetchExercisesReturnsStubbedExercises() async throws {
        let expected = [Exercise(title: "Tabata", activeSeconds: 20, restSeconds: 10, repetitions: 8)]
        fetchExercisesUseCase.stubbedExercises = expected
        let result = try await sut.fetchExercises()
        XCTAssertEqual(result, expected)
    }

    func testFetchExercisesRethrowsError() async {
        fetchExercisesUseCase.shouldThrow = true
        do {
            _ = try await sut.fetchExercises()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - createSchedule

    func testCreateScheduleDelegatesToUseCaseWithCorrectExerciseId() async throws {
        let exerciseId = UUID()
        let days = [DaySchedule(dayOfWeek: .tuesday, reminderHour: 7, reminderMinute: 30)]
        _ = try await sut.createSchedule(exerciseId: exerciseId, daySchedules: days)
        let created = try XCTUnwrap(createScheduleUseCase.lastCreated)
        XCTAssertEqual(created.exerciseId, exerciseId)
    }

    func testCreateScheduleDelegatesToUseCaseWithCorrectDaySchedules() async throws {
        let days = [
            DaySchedule(dayOfWeek: .monday, reminderHour: 6, reminderMinute: 0),
            DaySchedule(dayOfWeek: .friday, reminderHour: 18, reminderMinute: 0)
        ]
        _ = try await sut.createSchedule(exerciseId: UUID(), daySchedules: days)
        let created = try XCTUnwrap(createScheduleUseCase.lastCreated)
        XCTAssertEqual(created.daySchedules.count, 2)
        XCTAssertEqual(created.daySchedules[0].dayOfWeek, .monday)
        XCTAssertEqual(created.daySchedules[1].dayOfWeek, .friday)
    }

    func testCreateScheduleRethrowsError() async {
        createScheduleUseCase.shouldThrow = true
        do {
            _ = try await sut.createSchedule(exerciseId: UUID(), daySchedules: [])
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - updateSchedule

    func testUpdateScheduleDelegatesToUseCase() async throws {
        let schedule = Schedule(exerciseId: UUID(), daySchedules: [])
        _ = try await sut.updateSchedule(schedule)
        XCTAssertEqual(updateScheduleUseCase.lastUpdated?.id, schedule.id)
    }

    func testUpdateScheduleRethrowsError() async {
        updateScheduleUseCase.shouldThrow = true
        do {
            _ = try await sut.updateSchedule(Schedule(exerciseId: UUID(), daySchedules: []))
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - deleteSchedule

    func testDeleteScheduleDelegatesToUseCaseWithCorrectId() async throws {
        let id = UUID()
        try await sut.deleteSchedule(id: id)
        XCTAssertEqual(deleteScheduleUseCase.deletedID, id)
    }

    func testDeleteScheduleRethrowsError() async {
        deleteScheduleUseCase.shouldThrow = true
        do {
            try await sut.deleteSchedule(id: UUID())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
