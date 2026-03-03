// RepositoryError.swift
// EnduroTrack › Data
//
// Common errors thrown by repository implementations.

import Foundation

/// Errors that can be thrown by repository operations.
enum RepositoryError: LocalizedError {

    /// The requested resource was not found in the store.
    case notFound(id: UUID)

    /// A generic data decoding or persistence error.
    case persistenceFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Resource with ID \(id) was not found."
        case .persistenceFailed(let error):
            return "Persistence failed: \(error.localizedDescription)"
        }
    }
}
