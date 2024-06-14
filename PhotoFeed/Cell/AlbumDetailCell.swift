//
//  AlbumDetailCell.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 12.06.2024.
//

import UIKit

final class AlbumDetailCell: UITableViewCell {

    static var reuseIdentifier: String { String(describing: self) }

    private var action: (() -> Void)?

    private lazy var touchController: UIControl = {
        let view = ResizableContainer()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(didSelectCell), for: .touchUpInside)
        return view
    }()

    private lazy var imageGridViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var imageGridView: UIView = {
        let topHorizontalStackView = UIStackView()
        topHorizontalStackView.axis = .horizontal
        topHorizontalStackView.addArrangedSubview(topLeftImageView)
        topHorizontalStackView.addArrangedSubview(topRightImageView)
        topHorizontalStackView.distribution = .fillEqually

        let bottomHorizontalStackView = UIStackView()
        bottomHorizontalStackView.axis = .horizontal
        bottomHorizontalStackView.addArrangedSubview(bottomLeftImageView)
        bottomHorizontalStackView.addArrangedSubview(bottomRightImageView)
        bottomHorizontalStackView.distribution = .fillEqually


        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.addArrangedSubview(topHorizontalStackView)
        verticalStackView.addArrangedSubview(bottomHorizontalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.distribution = .fillEqually
        verticalStackView.layer.cornerRadius = 16
        verticalStackView.clipsToBounds = true

        return verticalStackView
    }()

    private lazy var topLeftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var topRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var bottomLeftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var bottomRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.isUserInteractionEnabled = true
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: AlbumModel, action: @escaping () -> Void) {
        titleLabel.text = model.title
        topLeftImageView.image = model.thumbNails[0]
        topRightImageView.image = model.thumbNails[1]
        bottomLeftImageView.image = model.thumbNails[2]
        bottomRightImageView.image = model.thumbNails[3]
        self.action = action
    }

    override func prepareForReuse() {
        topLeftImageView.image = nil
        topRightImageView.image = nil
        bottomLeftImageView.image = nil
        bottomRightImageView.image = nil
        super.prepareForReuse()
    }
}

private extension AlbumDetailCell {

    @objc
    func didSelectCell() {
        action?()
    }

    func setupLayout() {
        contentView.addSubview(touchController)
        touchController.addSubview(imageGridViewContainer)
        touchController.addSubview(titleLabel)
        imageGridViewContainer.addSubview(imageGridView)

        NSLayoutConstraint.activate([
            touchController.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            touchController.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            touchController.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            touchController.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            imageGridView.topAnchor.constraint(equalTo: imageGridViewContainer.topAnchor, constant: 8),
            imageGridView.leadingAnchor.constraint(equalTo: imageGridViewContainer.leadingAnchor, constant: 8),
            imageGridView.trailingAnchor.constraint(equalTo: imageGridViewContainer.trailingAnchor, constant: -8),
            imageGridView.bottomAnchor.constraint(equalTo: imageGridViewContainer.bottomAnchor, constant: -8),

            imageGridViewContainer.topAnchor.constraint(equalTo: touchController.topAnchor, constant: 16),
            imageGridViewContainer.leadingAnchor.constraint(equalTo: touchController.leadingAnchor, constant: 16),
            imageGridViewContainer.bottomAnchor.constraint(equalTo: touchController.bottomAnchor, constant: -16),
            imageGridViewContainer.heightAnchor.constraint(equalToConstant: 150),
            imageGridViewContainer.widthAnchor.constraint(equalTo: imageGridViewContainer.heightAnchor, multiplier: 1),

            titleLabel.topAnchor.constraint(equalTo: touchController.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: imageGridViewContainer.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: touchController.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: touchController.bottomAnchor, constant: -16)
        ])
    }
}
