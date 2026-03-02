//
//  MusicService.swift
//  APIapp
//
//  Created by victoria on 02.03.2026.
//

import Foundation

final class MusicService {

    // MARK: - Constants

    private enum Constant {
        static let baseURL = "https://itunes.apple.com/search"
        static let pageLimit = 50
        static let genre = "electronic"
    }

    // MARK: - Properties

    static let shared = MusicService()

    private init() { }

    // MARK: - Methods

    func fetchPage(offset: Int) async throws -> TrackPage {
        var components = URLComponents(string: Constant.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "term", value: Constant.genre),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "\(Constant.pageLimit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]

        guard let url = components?.url else { throw URLError(.badURL) }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TrackPage.self, from: data)
    }
}
