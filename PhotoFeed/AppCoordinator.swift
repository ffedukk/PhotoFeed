//
//  AppCoordinator.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 12.06.2024.
//

import UIKit

@MainActor
final class AppCoordinator {

    weak var navigationController: UINavigationController?

    private let window: UIWindow
    private let networkService = NetworkService()

    init(window: UIWindow) {
        self.window = window
    }
}

extension AppCoordinator {

    func launch() {
        let presenter = AlbumFeedPresenter(appCoordinator: self, networkService: networkService)
        let controller = AlbumFeedViewController(presenter: presenter)
        presenter.view = controller

        let navigationController = UINavigationController(rootViewController: controller)
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func pushPhotoFeedController(with albumId: Int) {
        let presenter = PhotoFeedPresenter(appCoordinator: self, networkService: networkService)
        let controller = PhotoFeedViewController(presenter: presenter, albumId: albumId)
        presenter.view = controller

        navigationController?.pushViewController(controller, animated: true)
    }
}
