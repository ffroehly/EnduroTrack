//
//  EnduroTrackTests.swift
//  EnduroTrackTests
//
//  Created by Fabrice FROEHLY on 02/03/2026.
//

import XCTest
@testable import EnduroTrack

final class EnduroTrackTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

// MARK: - ExerciseSoundPlayer Tests

final class ExerciseSoundPlayerTests: XCTestCase {

    private let player = ExerciseSoundPlayer()

    func testWarmupSoundID() {
        XCTAssertEqual(player.soundID(for: .warmup), 1052)
    }

    func testActiveSoundID() {
        XCTAssertEqual(player.soundID(for: .active(rep: 1)), 1016)
        XCTAssertEqual(player.soundID(for: .active(rep: 3)), 1016)
    }

    func testRestSoundID() {
        XCTAssertEqual(player.soundID(for: .rest(rep: 1)), 1054)
        XCTAssertEqual(player.soundID(for: .rest(rep: 5)), 1054)
    }

    func testRecoverySoundID() {
        XCTAssertEqual(player.soundID(for: .recovery), 1021)
    }

    func testAllPhasesReturnDistinctSoundIDs() {
        let ids = [
            player.soundID(for: .warmup),
            player.soundID(for: .active(rep: 1)),
            player.soundID(for: .rest(rep: 1)),
            player.soundID(for: .recovery)
        ]
        XCTAssertEqual(Set(ids).count, ids.count, "Each phase should have a unique sound ID")
    }
}
