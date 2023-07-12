import Foundation
import UIKit
import Then
import SDWebImage
import SnapKit

class HeroInfoItemCollectionViewCell: UICollectionViewCell {
    private var model: HeroInfoItemCollectionViewCellModel!
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = .white
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        self.nameLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(6)
        }
        
        self.imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(6)
            $0.bottom.equalTo(nameLabel.snp.top).offset(4)
        }
    }
    
    private func setupUI() {
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        self.layer.borderWidth = 1
    }
}

// MARK: Configure

extension HeroInfoItemCollectionViewCell {
    func configure(with model: HeroInfoItemCollectionViewCellModel) {
        self.model = model
        
        nameLabel.text = model.name
        imageView.sd_setImage(with: URL(string: model.image))
    }
}
