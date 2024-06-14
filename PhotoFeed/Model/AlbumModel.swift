//
//  AlbumModel.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 12.06.2024.
//

import UIKit

struct AlbumModel: Decodable {
    let userId: Int
    let id: Int
    let title: String
    var thumbNails: [UIImage?] = []

    enum CodingKeys: CodingKey {
        case userId
        case id
        case title
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }
}
