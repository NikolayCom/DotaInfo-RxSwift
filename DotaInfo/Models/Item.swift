//
//  Item.swift
//  DotaInfo
//
//  Created by Nikolay Pivnik on 11.07.23.
//

import Foundation

struct Item: Decodable {
    let id: Int
    let localizedName: String
    let name: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case localizedName = "localized_name"
        case name
        case image = "url_image"
    }
}

struct SortedHeroItems {
    let startGame: [Item]
    let earlyGame: [Item]
    let midGame: [Item]
    let lateGame: [Item]
}
