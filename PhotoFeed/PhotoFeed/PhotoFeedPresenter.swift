//
//  PhotoFeedPresenter.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 05.06.2024.
//

import Foundation

protocol PhotoFeedViewOutput: AnyObject, Sendable {

    func getPhotos(from albumId: Int) async throws -> [PhotoModel]
}

final class PhotoFeedPresenter: @unchecked Sendable {

    weak var view: PhotoFeedViewInput?

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

extension PhotoFeedPresenter: PhotoFeedViewOutput {

    func getPhotos(from albumId: Int) async throws -> [PhotoModel] {
        try await networkService.loadPhotos(from: albumId)
    }

}
