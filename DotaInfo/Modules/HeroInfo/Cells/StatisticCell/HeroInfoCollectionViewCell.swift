import Foundation
import UIKit
import Then
import SDWebImage
import SnapKit
import RxSwift

class HeroInfoCollectionViewCell: UICollectionViewCell {
    private var model: HeroInfoCollectionViewCellModel!
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var descriptionLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = .white
        $0.sizeToFit()
    }
    
    private var valueLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = .white
        // $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private var contentStackView = UIStackView().then {
        $0.spacing = 16
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
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(UIView())
        contentStackView.addArrangedSubview(valueLabel)
        // contentStackView.addArrangedSubview(UIView())
        
        // self.imageView.snp.makeConstraints {
            // $0.size.equalTo(44)
        // }
        
        self.contentStackView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupUI() {
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.layer.borderWidth = 1
    }
}

// MARK: Configure

extension HeroInfoCollectionViewCell {
    func configure(with model: HeroInfoCollectionViewCellModel) {
        self.model = model
        
        if let name = model.imageName {
            imageView.image = UIImage(named: name)
        } else {
            imageView.removeFromSuperview()
        }
        
        descriptionLabel.text = model.description
        valueLabel.text = model.title
    }
}
