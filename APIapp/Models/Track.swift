//
//  Track.swift
//  APIapp
//
//  Created by victoria on 02.03.2026.
//

import Foundation

struct TrackPage: Decodable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Decodable, Identifiable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackTimeMillis: Int?

    var id: Int { trackId }

    var artworkURL: URL? {
        guard let artworkUrl100 else { return nil }
        return URL(string: artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300"))
    }

    var duration: String {
        guard let ms = trackTimeMillis else { return "—" }
        let totalSeconds = ms / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
