//
//  AlbumFeedViewController.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 12.06.2024.
//

import UIKit

@MainActor
protocol AlbumFeedViewInput: AnyObject {

}

final class AlbumFeedViewController: UIViewController {

    private let presenter: AlbumFeedViewOutput
    private var models: [AlbumModel] = []
    private var isLoading = false

    private lazy var tableView: UITableView = {
        let tableView = CustomTableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.register(AlbumDetailCell.self, forCellReuseIdentifier: AlbumDetailCell.reuseIdentifier)
        tableView.register(AlbumDetailShimmerCell.self, forCellReuseIdentifier: AlbumDetailShimmerCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(presenter: AlbumFeedViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "All Albums"
        view.backgroundColor = .darkGray
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            do {
                if models.isEmpty {
                    isLoading = true
                    tableView.reloadData()
                }
                let receivedModels = try await presenter.getAlbums(from: 1)
                models = receivedModels
                isLoading = false
                tableView.reloadData()
            } catch let error {
                print(error)
            }
        }
    }
}

extension AlbumFeedViewController: AlbumFeedViewInput {

}

extension AlbumFeedViewController: UITableViewDataSource & UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isLoading ? 1 : models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumDetailShimmerCell.reuseIdentifier)
            guard let cell else { return UITableViewCell() }
            return cell
        } else {
            let model = models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumDetailCell.reuseIdentifier)
            guard let cell = cell as? AlbumDetailCell else { return UITableViewCell() }
            cell.configure(with: model) { [weak self] in
                guard let self else { return }
                Task {
                    let albumId = self.models[indexPath.row].id
                    await self.presenter.openAlbum(with: albumId)
                }
            }
            return cell
        }
    }
}

private extension AlbumFeedViewController {

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
