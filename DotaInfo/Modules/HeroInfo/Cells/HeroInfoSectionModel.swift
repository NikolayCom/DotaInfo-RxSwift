import Foundation
import RxDataSources

enum HeroInfoSectionItem {
    case statistic(cellViewModel: HeroInfoCollectionViewCellModel)
    case items(cellViewModel: HeroInfoItemCollectionViewCellModel)
}

// MARK: HeroSectionModel

enum HeroInfoSectionModel {
    case statistic(items: [HeroInfoSectionItem])
    
    case earlyGame(items: [HeroInfoSectionItem])
    case startGame(items: [HeroInfoSectionItem])
    case midGame(items: [HeroInfoSectionItem])
    case lateGame(items: [HeroInfoSectionItem])
}

// MARK: HeroSectionModel + SectionModelType

extension HeroInfoSectionModel: SectionModelType {
    typealias Item = HeroInfoSectionItem
    
    var title: String {
        switch self {
        case .statistic:
            return "Statistic"
            
        case .earlyGame:
            return "Early Game"
            
        case .startGame:
            return "Start Game"
            
        case .midGame:
            return "Mid Game"
            
        case .lateGame:
            return "Late Game"
        }
    }
    
    var items: [HeroInfoSectionItem] {
        switch self {
        case .statistic(let items):
            return items
            
        case .earlyGame(let items):
            return items
            
        case .startGame(let items):
            return items
            
        case .midGame(let items):
            return items
            
        case .lateGame(let items):
            return items
        }
    }
    
    init(original: HeroInfoSectionModel, items: [HeroInfoSectionItem]) {
        self = original
    }
}

