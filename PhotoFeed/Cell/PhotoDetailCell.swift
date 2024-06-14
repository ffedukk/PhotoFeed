//
//  PhotoDetailCell.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 05.06.2024.
//

import UIKit

final class PhotoDetailCell: UITableViewCell {

    static var reuseIdentifier: String { String(describing: self) }

    private var loadTask: Task<Void, Never>?

    private lazy var containerView: UIView = {
        let view = ResizableContainer()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .darkGray
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: PhotoModel) {
        titleLabel.text = model.title
        loadImage(from: model.url)
    }

    override func prepareForReuse() {
        loadTask?.cancel()
        photoImageView.image = nil
        super.prepareForReuse()
    }
}

private extension PhotoDetailCell {

    func loadImage(from urlString: String) {
//        loadTask = Task {
//            do {
//                let imageLoader = ImageLoader(urlString: urlString)
//                let image = try await imageLoader.image
//                photoImageView.image = image
//            } catch let error {
//                print(error)
//            }
//        }

        loadTask = Task {
            do {
                let imageLoader = ImageLoader(urlString: urlString)
                for try await event in imageLoader.loadingImageStream {
                    try Task.checkCancellation()
                    switch event {
                    case .loading(let percent):
                        try await Task.sleep(for: .seconds(1))
                        loadingLabel.text = "\(percent) %"
                    case .loaded(let image):
                        photoImageView.image = image
                        loadingLabel.text = ""
                    }
                }
            } catch let error {
                loadingLabel.text = ""
                print(error)
            }
        }
    }

    func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(photoImageView)
        containerView.addSubview(loadingLabel)

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            photoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            photoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            photoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            photoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1),

            loadingLabel.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}
