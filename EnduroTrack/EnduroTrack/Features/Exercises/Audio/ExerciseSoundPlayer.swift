// ExerciseSoundPlayer.swift
// EnduroTrack › Features › Exercises › Audio

import AudioToolbox
import AVFoundation

/// Plays a distinctive system sound for each exercise timer phase transition.
/// Configures AVAudioSession with the `.playback` category so that sounds
/// play even when the device's silent switch is engaged.
struct ExerciseSoundPlayer {

    // Configured once the first time any ExerciseSoundPlayer is used.
    private static let audioSessionConfigured: Void = {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session configuration failed; sounds will respect the silent switch
        }
    }()

    init() {
        _ = ExerciseSoundPlayer.audioSessionConfigured
    }

    /// Plays the appropriate system sound for the given timer phase.
    func play(for phase: TimerPhase) {
        AudioServicesPlaySystemSound(soundID(for: phase))
    }

    /// Plays the completion sound when an exercise session finishes.
    func playFinished() {
        AudioServicesPlaySystemSound(Self.finishedSoundID)
    }

    // MARK: - Private

    private static let finishedSoundID: SystemSoundID = 1025  // fanfare

    func soundID(for phase: TimerPhase) -> SystemSoundID {
        switch phase {
        case .warmup:
            return 1052  // SIMToolkitGeneralBeep – neutral single beep
        case .active:
            return 1016  // tweet_sent – short upbeat chirp
        case .rest:
            return 1054  // SIMToolkitPositiveACK – calm descending tone
        case .recovery:
            return 1021  // bloom – gentle mellow tone
        }
    }
}
