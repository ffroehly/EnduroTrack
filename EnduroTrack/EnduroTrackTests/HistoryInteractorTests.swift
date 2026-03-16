// HistoryInteractorTests.swift
// EnduroTrackTests
//
// Unit tests for HistoryInteractor.
// Dependencies are injected via protocols (Dependency Inversion).
// Each test class is responsible for one component (Single Responsibility).

import XCTest
import Domain
@testable import EnduroTrack

final class HistoryInteractorTests: XCTestCase {

    // MARK: - Properties

    private var fetchSessionsUseCase: MockFetchExerciseSessionsUseCase!
    private var sut: HistoryInteractor!

    // MARK: - setUp / tearDown

    override func setUp() {
        super.setUp()
        fetchSessionsUseCase = MockFetchExerciseSessionsUseCase()
        sut = HistoryInteractor(fetchSessionsUseCase: fetchSessionsUseCase)
    }

    override func tearDown() {
        sut = nil
        fetchSessionsUseCase = nil
        super.tearDown()
    }

    // MARK: - fetchAllSessions

    func testFetchAllSessionsReturnsStubbedSessions() async throws {
        let exerciseId = UUID()
        let sessions = [
            ExerciseSession(exerciseId: exerciseId, exerciseTitle: "Tabata", durationSeconds: 225),
            ExerciseSession(exerciseId: exerciseId, exerciseTitle: "Tabata", durationSeconds: 200)
        ]
        fetchSessionsUseCase.stubbedSessions = sessions
        let result = try await sut.fetchAllSessions()
        XCTAssertEqual(result.count, 2)
    }

    func testFetchAllSessionsReturnsEmptyArray() async throws {
        fetchSessionsUseCase.stubbedSessions = []
        let result = try await sut.fetchAllSessions()
        XCTAssertTrue(result.isEmpty)
    }

    func testFetchAllSessionsRethrowsError() async {
        fetchSessionsUseCase.shouldThrow = true
        do {
            _ = try await sut.fetchAllSessions()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testFetchAllSessionsPreservesSessionData() async throws {
        let exerciseId = UUID()
        let session = ExerciseSession(
            exerciseId: exerciseId,
            exerciseTitle: "Sprint",
            durationSeconds: 300
        )
        fetchSessionsUseCase.stubbedSessions = [session]
        let result = try await sut.fetchAllSessions()
        let returnedSession = try XCTUnwrap(result.first)
        XCTAssertEqual(returnedSession.exerciseId, exerciseId)
        XCTAssertEqual(returnedSession.exerciseTitle, "Sprint")
        XCTAssertEqual(returnedSession.durationSeconds, 300)
    }
}
