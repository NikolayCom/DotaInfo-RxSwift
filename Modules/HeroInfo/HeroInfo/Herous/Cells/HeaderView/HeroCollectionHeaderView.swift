import Foundation
import UIKit
import SnapKit

// MARK: HeroCollectionHeaderView

class HeroCollectionHeaderView: UICollectionViewCell {
    private var model: HeroCollectionSectionModel!
    
    var titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = .white
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}

// MARK: Configure

extension HeroCollectionHeaderView {
    func configure(with model: HeroCollectionSectionModel) {
        self.model = model
        
        titleLabel.text = model.title
    }
}
