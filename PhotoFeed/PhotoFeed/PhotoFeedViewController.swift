//
//  PhotoFeedViewController.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 05.06.2024.
//

import UIKit

@MainActor
protocol PhotoFeedViewInput: AnyObject {

}

final class PhotoFeedViewController: UIViewController {

    private let presenter: PhotoFeedViewOutput
    private let albumId: Int
    private var models: [PhotoModel] = []

    private lazy var tableView: UITableView = {
        let tableView = CustomTableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .darkGray
        tableView.separatorColor = .clear
        tableView.register(PhotoDetailCell.self, forCellReuseIdentifier: PhotoDetailCell.reuseIdentifier)
        tableView.dataSource = self
        return tableView
    }()

    init(presenter: PhotoFeedViewOutput, albumId: Int) {
        self.presenter = presenter
        self.albumId = albumId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Album \(albumId)"
        view.backgroundColor = .gray
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            do {
                let receivedModels = try await presenter.getPhotos(from: albumId)
                models = receivedModels
                tableView.reloadData()
            } catch let error {
                print(error)
            }
        }
    }
}

extension PhotoFeedViewController: PhotoFeedViewInput {

}

extension PhotoFeedViewController: UITableViewDataSource & UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoDetailCell.reuseIdentifier) as? PhotoDetailCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: model)
        return cell
    }
}

private extension PhotoFeedViewController {

    func setupLayout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
