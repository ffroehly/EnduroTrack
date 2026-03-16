// ExercisesInteractorTests.swift
// EnduroTrackTests
//
// Unit tests for ExercisesInteractor.
// Dependencies are injected via protocols (Dependency Inversion).
// Each test class is responsible for one component (Single Responsibility).

import XCTest
import Domain
@testable import EnduroTrack

final class ExercisesInteractorTests: XCTestCase {

    // MARK: - Properties

    private var fetchExercisesUseCase: MockFetchExercisesUseCase!
    private var createExerciseUseCase: MockCreateExerciseUseCase!
    private var updateExerciseUseCase: MockUpdateExerciseUseCase!
    private var deleteExerciseUseCase: MockDeleteExerciseUseCase!
    private var saveSessionUseCase: MockSaveExerciseSessionUseCase!
    private var sut: ExercisesInteractor!

    // MARK: - setUp / tearDown

    override func setUp() {
        super.setUp()
        fetchExercisesUseCase = MockFetchExercisesUseCase()
        createExerciseUseCase = MockCreateExerciseUseCase()
        updateExerciseUseCase = MockUpdateExerciseUseCase()
        deleteExerciseUseCase = MockDeleteExerciseUseCase()
        saveSessionUseCase = MockSaveExerciseSessionUseCase()
        sut = ExercisesInteractor(
            fetchExercisesUseCase: fetchExercisesUseCase,
            createExerciseUseCase: createExerciseUseCase,
            updateExerciseUseCase: updateExerciseUseCase,
            deleteExerciseUseCase: deleteExerciseUseCase,
            saveSessionUseCase: saveSessionUseCase
        )
    }

    override func tearDown() {
        sut = nil
        fetchExercisesUseCase = nil
        createExerciseUseCase = nil
        updateExerciseUseCase = nil
        deleteExerciseUseCase = nil
        saveSessionUseCase = nil
        super.tearDown()
    }

    // MARK: - fetchExercises

    func testFetchExercisesReturnsStubbedExercises() async throws {
        let expected = [Exercise(title: "Tabata", activeSeconds: 20, restSeconds: 10, repetitions: 8)]
        fetchExercisesUseCase.stubbedExercises = expected
        let result = try await sut.fetchExercises()
        XCTAssertEqual(result, expected)
    }

    func testFetchExercisesReturnsEmptyArray() async throws {
        fetchExercisesUseCase.stubbedExercises = []
        let result = try await sut.fetchExercises()
        XCTAssertTrue(result.isEmpty)
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

    // MARK: - createExercise

    func testCreateExerciseDelegatesToUseCaseWithCorrectValues() async throws {
        _ = try await sut.createExercise(
            title: "Sprint",
            warmupSeconds: 10,
            activeSeconds: 30,
            restSeconds: 15,
            repetitions: 6,
            recoverySeconds: 60
        )
        let created = try XCTUnwrap(createExerciseUseCase.lastCreated)
        XCTAssertEqual(created.title, "Sprint")
        XCTAssertEqual(created.warmupSeconds, 10)
        XCTAssertEqual(created.activeSeconds, 30)
        XCTAssertEqual(created.restSeconds, 15)
        XCTAssertEqual(created.repetitions, 6)
        XCTAssertEqual(created.recoverySeconds, 60)
    }

    func testCreateExerciseWithNilRecovery() async throws {
        _ = try await sut.createExercise(
            title: "Workout",
            warmupSeconds: 5,
            activeSeconds: 20,
            restSeconds: 10,
            repetitions: 4,
            recoverySeconds: nil
        )
        let created = try XCTUnwrap(createExerciseUseCase.lastCreated)
        XCTAssertNil(created.recoverySeconds)
    }

    func testCreateExerciseRethrowsError() async {
        createExerciseUseCase.shouldThrow = true
        do {
            _ = try await sut.createExercise(
                title: "Workout",
                warmupSeconds: 5,
                activeSeconds: 20,
                restSeconds: 10,
                repetitions: 4,
                recoverySeconds: nil
            )
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - updateExercise

    func testUpdateExerciseDelegatesToUseCase() async throws {
        let exercise = Exercise(title: "Updated", activeSeconds: 40, restSeconds: 20, repetitions: 5)
        _ = try await sut.updateExercise(exercise)
        XCTAssertEqual(updateExerciseUseCase.lastUpdated, exercise)
    }

    func testUpdateExerciseRethrowsError() async {
        updateExerciseUseCase.shouldThrow = true
        let exercise = Exercise(title: "T", activeSeconds: 20, restSeconds: 10, repetitions: 4)
        do {
            _ = try await sut.updateExercise(exercise)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - deleteExercise

    func testDeleteExerciseDelegatesToUseCaseWithCorrectId() async throws {
        let id = UUID()
        try await sut.deleteExercise(id: id)
        XCTAssertEqual(deleteExerciseUseCase.deletedID, id)
    }

    func testDeleteExerciseRethrowsError() async {
        deleteExerciseUseCase.shouldThrow = true
        do {
            try await sut.deleteExercise(id: UUID())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - saveSession

    func testSaveSessionDelegatesToUseCase() async throws {
        let session = ExerciseSession(exerciseId: UUID(), exerciseTitle: "Tabata", durationSeconds: 225)
        _ = try await sut.saveSession(session)
        XCTAssertEqual(saveSessionUseCase.lastSaved?.id, session.id)
    }

    func testSaveSessionRethrowsError() async {
        saveSessionUseCase.shouldThrow = true
        let session = ExerciseSession(exerciseId: UUID(), exerciseTitle: "T", durationSeconds: 60)
        do {
            _ = try await sut.saveSession(session)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
