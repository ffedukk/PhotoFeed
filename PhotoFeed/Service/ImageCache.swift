//
//  ImageCache.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 06.06.2024.
//

import UIKit

actor ImageCache {

    static let shared = ImageCache()
    private let cachedImages = NSCache<AnyObject, UIImage>()
    private init() {}

    func image(from url: URL) -> UIImage? {
        cachedImages.object(forKey: url as AnyObject)
    }

    func insert(image: UIImage, for url: URL, cost: Int) {
        cachedImages.setObject(image, forKey: url as AnyObject, cost: cost)
    }
}
