import Foundation
import UIKit

extension NSCollectionLayoutSection {
    public static func verticalListSection(
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .clear
        configuration.showsSeparators = false
        return NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: layoutEnvironment
        )
    }
    
    public static func tilesSection(tileIndex: CGFloat) -> NSCollectionLayoutSection {
        let spacing: CGFloat = 4
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(tileIndex),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(tileIndex))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(54)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
       
        return section
    }
}
