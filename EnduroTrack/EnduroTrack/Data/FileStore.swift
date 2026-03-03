// FileStore.swift
// EnduroTrack › Data
//
// Generic JSON persistence store using FileManager.
// Stores data as a JSON array in the app's Documents directory.

import Foundation

/// A simple, generic JSON persistence store backed by the filesystem.
/// Thread-safe via async/await; uses the calling actor's context.
final class FileStore<T: Codable & Sendable>: @unchecked Sendable {

    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(filename: String) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = docs.appendingPathComponent(filename)
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func load() throws -> [T] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([T].self, from: data)
    }

    func save(_ items: [T]) throws {
        let data = try encoder.encode(items)
        try data.write(to: fileURL, options: .atomic)
    }
}
