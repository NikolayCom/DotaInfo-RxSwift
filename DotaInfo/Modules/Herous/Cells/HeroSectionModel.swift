import Foundation
import RxDataSources

// MARK: HeroSectionItem

enum HeroSectionItem {
    case normal(cellViewModel: HeroCollectionViewCellModel)
    case error(message: String)
    case empty
}

// MARK: HeroSectionModel

enum HeroSectionModel {
    enum Section: String {
        case force = "str"
        case dexterity = "agi"
        case intelligence = "int"
        case universal = "all"
    }
    
    case force(items: [HeroSectionItem])
    case dexterity(items: [HeroSectionItem])
    case intelligence(items: [HeroSectionItem])
    case universal(items: [HeroSectionItem])
}

// MARK: HeroSectionModel + SectionModelType

extension HeroSectionModel: SectionModelType {
    typealias Item = HeroSectionItem
    
    var title: String {
        switch self {
        case .force:
            return "Force"
            
        case .dexterity:
            return "Dexterity"
            
        case .intelligence:
            return "Intelligence"
            
        case .universal:
            return "Universal"
        }
    }
    
    var items: [HeroSectionItem] {
        switch self {
        case .force(let items):
            return items
            
            
        case .dexterity(let items):
            return items
            
            
        case .intelligence( let items):
            return items
            
            
        case .universal(let items):
            return items
        }
    }
    
    init(original: HeroSectionModel, items: [HeroSectionItem]) {
        self = original
    }
}


