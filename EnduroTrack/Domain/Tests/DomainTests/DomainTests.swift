//
//  DomainTests.swift
//  DomainTests
//

import Testing
@testable import Domain

// MARK: - Mock

/// In-memory mock that satisfies WorkoutRepositoryProtocol for testing.
private actor MockWorkoutRepository: WorkoutRepositoryProtocol {
    private(set) var savedWorkouts: [Workout] = []

    func fetchAll() async throws -> [Workout] { savedWorkouts }

    func save(_ workout: Workout) async throws {
        savedWorkouts.append(workout)
    }

    func delete(id: UUID) async throws {
        savedWorkouts.removeAll { $0.id == id }
    }
}

// MARK: - Duration Tests

@Suite("Duration Tests")
struct DurationTests {

    @Test("Duration formatted correctly for hours/minutes/seconds")
    func testDurationFormatted() {
        let d = Duration(seconds: 3665) // 1h 1m 5s
        #expect(d.formatted == "1h 01m 05s")
    }

    @Test("Duration formatted correctly for minutes only")
    func testDurationFormattedMinutes() {
        let d = Duration(seconds: 305) // 5m 5s
        #expect(d.formatted == "5m 05s")
    }

    @Test("Duration convenience initialisers")
    func testDurationConvenience() {
        #expect(Duration.minutes(2).seconds == 120)
        #expect(Duration.hours(1).seconds == 3600)
    }
}

// MARK: - Distance Tests

@Suite("Distance Tests")
struct DistanceTests {

    @Test("Distance conversion from km to metres")
    func testDistanceKm() {
        let d = Distance.kilometres(5)
        #expect(d.metres == 5_000)
        #expect(d.formattedKm == "5.00 km")
    }

    @Test("Distance conversion from miles to metres")
    func testDistanceMiles() {
        let d = Distance.miles(1)
        #expect(abs(d.metres - 1_609.344) < 0.001)
    }
}

// MARK: - WorkoutUseCase Tests

@Suite("Workout Use Case Tests")
struct WorkoutUseCaseTests {

    @Test("SaveWorkoutUseCase rejects empty name")
    func testSaveWorkoutEmptyName() async {
        let repo = MockWorkoutRepository()
        let useCase = SaveWorkoutUseCase(repository: repo)
        let workout = Workout(
            name: "",
            duration: .minutes(30),
            difficulty: .medium
        )
        await #expect(throws: WorkoutError.invalidName) {
            try await useCase.execute(workout)
        }
    }

    @Test("SaveWorkoutUseCase saves valid workout")
    func testSaveWorkoutValid() async throws {
        let repo = MockWorkoutRepository()
        let useCase = SaveWorkoutUseCase(repository: repo)
        let workout = Workout(
            name: "Morning Run",
            duration: .minutes(30),
            difficulty: .easy
        )
        try await useCase.execute(workout)
        let saved = await repo.savedWorkouts
        #expect(saved.count == 1)
        #expect(saved.first?.name == "Morning Run")
    }

    @Test("FetchWorkoutsUseCase returns empty list initially")
    func testFetchWorkoutsEmpty() async throws {
        let repo = MockWorkoutRepository()
        let useCase = FetchWorkoutsUseCase(repository: repo)
        let result = try await useCase.execute()
        #expect(result.isEmpty)
    }
}
