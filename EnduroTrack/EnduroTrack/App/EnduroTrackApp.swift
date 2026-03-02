//
//  EnduroTrackApp.swift
//  EnduroTrack
//
//  Created by Fabrice FROEHLY on 02/03/2026.
//

import SwiftUI
import ComposableArchitecture

@main
struct EnduroTrackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: AppReducer.State()) {
                    AppReducer()
                }
            )
        }
    }
}
