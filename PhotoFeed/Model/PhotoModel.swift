//
//  PhotoModel.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 05.06.2024.
//

import Foundation

struct PhotoModel: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
