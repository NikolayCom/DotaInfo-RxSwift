import Foundation
import RxSwift
import UIKit
import PKHUD
import RxDataSources
import SnapKit
import SDWebImage
import Then

class HeroInfoViewController: UIViewController {
    private (set) var viewModel: HeroInfoViewModelInterface
    
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.register(HeroInfoItemCollectionViewCell.self, forCellWithReuseIdentifier: "hero.info.item.collection.cell")
        $0.register(HeroInfoCollectionViewCell.self, forCellWithReuseIdentifier: "hero.info.collection.cell")
        $0.register(HeroCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "hero.collection.header")
        $0.backgroundColor = .clear
    }
    
    private lazy var iconImageView = UIImageView()
    
    private lazy var backgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    private lazy var nameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 24)
    }
    
    init(viewModel: HeroInfoViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        bindViewModel()
        viewModel.loadView()
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(nameLabel)
        view.addSubview(iconImageView)
        
        backgroundImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(iconImageView)
        }
       
        collectionView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

private extension HeroInfoViewController {
    func getCollectionLayout(cells: [HeroInfoSectionModel]) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] section, layoutEnvironment in
            switch cells[section] {
            case .statistic:
                return .verticalListSection(layoutEnvironment: layoutEnvironment)
                
            case .startGame, .earlyGame, .midGame, .lateGame:
                return .tilesSection(tileIndex: 0.25)
            }
        }
    }
        
    func getCollectionDataSource() -> RxCollectionViewSectionedReloadDataSource<HeroInfoSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<HeroInfoSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath] {
                case .statistic(let cellViewModel):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hero.info.collection.cell", for: indexPath) as? HeroInfoCollectionViewCell
                    else { return UICollectionViewCell() }
                    
                    cell.configure(with: cellViewModel)
                    return cell
                    
                case .items(let cellViewModel):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hero.info.item.collection.cell", for: indexPath) as? HeroInfoItemCollectionViewCell
                    else { return UICollectionViewCell() }
                    
                    cell.configure(with: cellViewModel)
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard let cell = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "hero.collection.header", for: indexPath) as? HeroCollectionHeaderView
                else { return UICollectionViewCell() }
                
                cell.configure(with: .init(title: dataSource[indexPath.section].title))
                
                return cell
            }
        )
    }
    
    func bindViewModel() {
        viewModel.loadView()
        
        viewModel.headerInfo
            .map {
                [unowned self] in
                self.backgroundImageView.sd_setImage(with: URL(string: $0.image))
                self.iconImageView.sd_setImage(with: URL(string: $0.icon))
                self.nameLabel.rx.text.onNext($0.localizedName)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.collectionCells
            .map({ [unowned self] cells in
                self.collectionView.setCollectionViewLayout(getCollectionLayout(cells: cells), animated: true)
            })
            .subscribe()
            .disposed(by: disposeBag)
    
        
        viewModel.collectionCells
            .bind(to: collectionView.rx.items(dataSource: getCollectionDataSource()))
            .disposed(by: disposeBag)
        
        viewModel.onShowLoadingHud
            .map { [unowned self] in self.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func setLoadingHud(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
}
