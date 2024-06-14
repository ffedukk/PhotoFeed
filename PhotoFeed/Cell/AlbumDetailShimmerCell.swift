//
//  AlbumDetailShimmerCell.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 13.06.2024.
//

import UIKit

final class AlbumDetailShimmerCell: UITableViewCell {

    static var reuseIdentifier: String { String(describing: self) }

    private lazy var firstShimmerView = shimmerView
    private lazy var secondShimmerView = shimmerView
    private lazy var thirdShimmerView = shimmerView
    private lazy var forthShimmerView = shimmerView
    private lazy var fifthShimmerView = shimmerView

    private lazy var firstShimmerLayer = gradientLayer
    private lazy var secondShimmerLayer = gradientLayer
    private lazy var thirdShimmerLayer = gradientLayer
    private lazy var forthShimmerLayer = gradientLayer
    private lazy var fifthShimmerLayer = gradientLayer

    private var shimmerView: UIView {
        let control = ResizableContainer()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.layer.cornerRadius = 16
        control.clipsToBounds = true
        return control
    }

    private var gradientLayer: CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        let titleGroup = makeAnimationGroup()
        titleGroup.beginTime = 0.0
        gradientLayer.add(titleGroup, forKey: "backgroundColor")
        return gradientLayer
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        firstShimmerLayer.frame = firstShimmerView.bounds
        secondShimmerLayer.frame = secondShimmerView.bounds
        thirdShimmerLayer.frame = thirdShimmerView.bounds
        forthShimmerLayer.frame = forthShimmerView.bounds
        fifthShimmerLayer.frame = fifthShimmerView.bounds
    }
}

private extension AlbumDetailShimmerCell {

    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1.5

        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.lightGray.cgColor
        anim1.toValue = UIColor.darkGray.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0

        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.darkGray.cgColor
        anim2.toValue = UIColor.lightGray.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false

        if let previousGroup = previousGroup {
            // Offset groups by 0.33 seconds for effect
            group.beginTime = previousGroup.beginTime + 0.33
        }

        return group
    }

    func setupLayout() {
        firstShimmerView.layer.addSublayer(firstShimmerLayer)
        secondShimmerView.layer.addSublayer(secondShimmerLayer)
        thirdShimmerView.layer.addSublayer(thirdShimmerLayer)
        forthShimmerView.layer.addSublayer(forthShimmerLayer)
        fifthShimmerView.layer.addSublayer(fifthShimmerLayer)

        contentView.addSubview(firstShimmerView)
        contentView.addSubview(secondShimmerView)
        contentView.addSubview(thirdShimmerView)
        contentView.addSubview(forthShimmerView)
        contentView.addSubview(fifthShimmerView)

        NSLayoutConstraint.activate([
            firstShimmerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            firstShimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            firstShimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            firstShimmerView.heightAnchor.constraint(equalToConstant: 150 + 32),

            secondShimmerView.topAnchor.constraint(equalTo: firstShimmerView.bottomAnchor, constant: 32),
            secondShimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            secondShimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            secondShimmerView.heightAnchor.constraint(equalToConstant: 150 + 32),

            thirdShimmerView.topAnchor.constraint(equalTo: secondShimmerView.bottomAnchor, constant: 32),
            thirdShimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thirdShimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            thirdShimmerView.heightAnchor.constraint(equalToConstant: 150 + 32),

            forthShimmerView.topAnchor.constraint(equalTo: thirdShimmerView.bottomAnchor, constant: 32),
            forthShimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            forthShimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            forthShimmerView.heightAnchor.constraint(equalToConstant: 150 + 32),

            fifthShimmerView.topAnchor.constraint(equalTo: forthShimmerView.bottomAnchor, constant: 32),
            fifthShimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            fifthShimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            fifthShimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            fifthShimmerView.heightAnchor.constraint(equalToConstant: 150 + 32)
        ])
    }
}
