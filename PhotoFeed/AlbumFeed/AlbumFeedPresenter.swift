//
//  AlbumFeedPresenter.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 12.06.2024.
//

import UIKit

protocol AlbumFeedViewOutput: AnyObject, Sendable {

    func getAlbums(from userId: Int) async throws -> [AlbumModel]

    @MainActor
    func openAlbum(with albumId: Int) async
}

final class AlbumFeedPresenter: @unchecked Sendable {

    weak var view: AlbumFeedViewInput?

    private unowned let appCoordinator: AppCoordinator
    private unowned let networkService: NetworkService

    init(
        appCoordinator: AppCoordinator,
        networkService: NetworkService
    ) {
        self.appCoordinator = appCoordinator
        self.networkService = networkService
    }
}

extension AlbumFeedPresenter: AlbumFeedViewOutput {

    func getAlbums(from userId: Int) async throws -> [AlbumModel] {
        let albums = try await networkService.loadAlbums(from: userId)
        return try await albums.asyncMap { album in
            var resultAlbum = album
            let thumbnailsUrls = try await self.networkService.loadThumbnails(from: album.id).map { $0.thumbnailUrl }
            let thumbnails = try await thumbnailsUrls.asyncMap { try await ImageLoader(urlString: $0).image }
            resultAlbum.thumbNails = thumbnails
            return resultAlbum
        }
    }

    func openAlbum(with albumId: Int) {
        appCoordinator.pushPhotoFeedController(with: albumId)
    }
}
