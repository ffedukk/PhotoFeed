//
//  NetworkService.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 05.06.2024.
//

import Foundation

final class NetworkService: Sendable {

    private let session = URLSession.shared

    func loadPhotos(from albumId: Int) async throws -> [PhotoModel] {
        let urlString = "https://jsonplaceholder.typicode.com/albums/\(albumId)/photos"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let (data, _) = try await session.data(from: url)
        let models = try JSONDecoder().decode([PhotoModel].self, from: data)
        return models
    }

    func loadAlbums(from userId: Int) async throws -> [AlbumModel] {
        let urlString = "https://jsonplaceholder.typicode.com/users/\(userId)/albums"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let (data, _) = try await session.data(from: url)
        let models = try JSONDecoder().decode([AlbumModel].self, from: data)
        return models
    }

    func loadThumbnails(from albumId: Int) async throws -> [PhotoModel] {
        let urlString = "https://jsonplaceholder.typicode.com/albums/\(albumId)/photos"
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        let (data, _) = try await session.data(from: url)
        let models = try JSONDecoder().decode([PhotoModel].self, from: data)
        return Array(models.prefix(4))
    }
}

extension NetworkService {

    enum NetworkError: Error {
        case invalidURL
        case decodeError
        case unknown
    }
}
