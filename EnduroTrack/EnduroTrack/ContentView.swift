//
//  ContentView.swift
//  EnduroTrack
//
//  Created by Fabrice FROEHLY on 02/03/2026.
//
// ⚠️  This file is kept for Xcode project compatibility.
//     The canonical ContentView has been moved to EnduroTrack/App/ContentView.swift.
//     See EnduroTrackApp.swift for migration instructions.

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
