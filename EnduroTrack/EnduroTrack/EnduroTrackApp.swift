//
//  EnduroTrackApp.swift
//  EnduroTrack
//
//  Created by Fabrice FROEHLY on 02/03/2026.
//
// ⚠️  This file is kept for Xcode project compatibility (it is the file currently
//     referenced by the .xcodeproj target). The canonical entry point and root view
//     have been moved to:
//       EnduroTrack/App/EnduroTrackApp.swift
//       EnduroTrack/App/ContentView.swift
//
// To complete the migration, open the project in Xcode:
//   1. Add the App/ folder to the EnduroTrack target.
//   2. Remove this file and ContentView.swift from the target (keep them or delete them).
//   3. Make sure EnduroTrack/App/EnduroTrackApp.swift is the @main entry point.

import SwiftUI

@main
struct EnduroTrackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
