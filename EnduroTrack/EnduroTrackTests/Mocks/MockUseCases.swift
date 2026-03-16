// MockUseCases.swift
// EnduroTrackTests › Mocks
//
// Mock implementations of Domain use case protocols.
// Each mock implements exactly one protocol (Interface Segregation).
// All mocks are injected via protocols so tests never depend on concrete types (Dependency Inversion).

import Foundation
import Domain

// MARK: - Shared

enum MockError: Error, Equatable {
    case generic
}

// MARK: - Exercise Use Case Mocks

final class MockFetchExercisesUseCase: FetchExercisesUseCaseProtocol, @unchecked Sendable {
    var stubbedExercises: [Exercise] = []
    var shouldThrow = false

    func fetchAll() async throws -> [Exercise] {
        if shouldThrow { throw MockError.generic }
        return stubbedExercises
    }
}

final class MockCreateExerciseUseCase: CreateExerciseUseCaseProtocol, @unchecked Sendable {
    var lastCreated: Exercise?
    var shouldThrow = false

    func create(exercise: Exercise) async throws -> Exercise {
        if shouldThrow { throw MockError.generic }
        lastCreated = exercise
        return exercise
    }
}

final class MockUpdateExerciseUseCase: UpdateExerciseUseCaseProtocol, @unchecked Sendable {
    var lastUpdated: Exercise?
    var shouldThrow = false

    func update(exercise: Exercise) async throws -> Exercise {
        if shouldThrow { throw MockError.generic }
        lastUpdated = exercise
        return exercise
    }
}

final class MockDeleteExerciseUseCase: DeleteExerciseUseCaseProtocol, @unchecked Sendable {
    var deletedID: UUID?
    var shouldThrow = false

    func delete(exerciseID: UUID) async throws {
        if shouldThrow { throw MockError.generic }
        deletedID = exerciseID
    }
}

// MARK: - ExerciseSession Use Case Mocks

final class MockFetchExerciseSessionsUseCase: FetchExerciseSessionsUseCaseProtocol, @unchecked Sendable {
    var stubbedSessions: [ExerciseSession] = []
    var shouldThrow = false

    func fetchAll() async throws -> [ExerciseSession] {
        if shouldThrow { throw MockError.generic }
        return stubbedSessions
    }
}

final class MockSaveExerciseSessionUseCase: SaveExerciseSessionUseCaseProtocol, @unchecked Sendable {
    var lastSaved: ExerciseSession?
    var shouldThrow = false

    func save(session: ExerciseSession) async throws -> ExerciseSession {
        if shouldThrow { throw MockError.generic }
        lastSaved = session
        return session
    }
}

final class MockDeleteExerciseSessionUseCase: DeleteExerciseSessionUseCaseProtocol, @unchecked Sendable {
    var deletedID: UUID?
    var shouldThrow = false

    func delete(sessionID: UUID) async throws {
        if shouldThrow { throw MockError.generic }
        deletedID = sessionID
    }
}

// MARK: - Schedule Use Case Mocks

final class MockFetchSchedulesUseCase: FetchSchedulesUseCaseProtocol, @unchecked Sendable {
    var stubbedSchedules: [Schedule] = []
    var shouldThrow = false

    func fetchAll() async throws -> [Schedule] {
        if shouldThrow { throw MockError.generic }
        return stubbedSchedules
    }
}

final class MockCreateScheduleUseCase: CreateScheduleUseCaseProtocol, @unchecked Sendable {
    var lastCreated: Schedule?
    var shouldThrow = false

    func create(schedule: Schedule) async throws -> Schedule {
        if shouldThrow { throw MockError.generic }
        lastCreated = schedule
        return schedule
    }
}

final class MockUpdateScheduleUseCase: UpdateScheduleUseCaseProtocol, @unchecked Sendable {
    var lastUpdated: Schedule?
    var shouldThrow = false

    func update(schedule: Schedule) async throws -> Schedule {
        if shouldThrow { throw MockError.generic }
        lastUpdated = schedule
        return schedule
    }
}

final class MockDeleteScheduleUseCase: DeleteScheduleUseCaseProtocol, @unchecked Sendable {
    var deletedID: UUID?
    var shouldThrow = false

    func delete(scheduleID: UUID) async throws {
        if shouldThrow { throw MockError.generic }
        deletedID = scheduleID
    }
}
