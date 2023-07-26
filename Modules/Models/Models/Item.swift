//
//  Item.swift
//  DotaInfo
//
//  Created by Nikolay Pivnik on 11.07.23.
//

import Foundation

public struct Item: Decodable {
    public let id: Int
    public let localizedName: String
    public let name: String
    public let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case localizedName = "localized_name"
        case name
        case image = "url_image"
    }
}

public struct SortedHeroItems {
    public let startGame: [Item]
    public let earlyGame: [Item]
    public let midGame: [Item]
    public let lateGame: [Item]
}
