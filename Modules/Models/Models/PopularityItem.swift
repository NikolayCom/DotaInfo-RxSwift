import Foundation


public struct HeroPopularityItems: Decodable {
    let startGame: [String: Int]
    let earlyGame: [String: Int]
    let midGame: [String: Int]
    let lateGame: [String: Int]
    
    enum CodingKeys: String, CodingKey {
        case startGame = "start_game_items"
        case earlyGame = "early_game_items"
        case midGame = "mid_game_items"
        case lateGame = "late_game_items"
    }
    
    public func getHeroItems(with items: [Item]) -> SortedHeroItems {
        .init(
            startGame: items.filter({ startGame.keys.map { Int($0) }.contains($0.id) }),
            earlyGame: items.filter({ earlyGame.keys.map { Int($0) }.contains($0.id) }),
            midGame: items.filter({ midGame.keys.map { Int($0) }.contains($0.id) }),
            lateGame: items.filter({ lateGame.keys.map { Int($0) }.contains($0.id) })
        )
    }
}

