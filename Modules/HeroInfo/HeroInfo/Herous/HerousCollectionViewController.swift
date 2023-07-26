import Foundation
import UIKit
import Then
import RxSwift
// import RxSwiftExt
import Extensions
import PKHUD
import SnapKit
import RxDataSources

// MARK: HerousCollectionViewController

public class HerousCollectionViewController: UIViewController {
    private (set) var viewModel: HerousCollectionViewModelInterface
    
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.setCollectionViewLayout(self.getCollectionLayout(), animated: true)
        $0.backgroundColor = .white
        $0.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: "hero.collection.cell")
        $0.register(HeroCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "hero.collection.header")
        $0.backgroundColor = .darkGray
        $0.keyboardDismissMode = .onDrag
    }
    
    private lazy var textFieldSearchView = UITextField().then {
        $0.layer.cornerRadius = 4
        $0.backgroundColor = .black.withAlphaComponent(0.4)
        $0.layer.masksToBounds = true
        $0.attributedPlaceholder = NSAttributedString(
            string: "Search Hero..",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    
    public init(viewModel: HerousCollectionViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.loadView()
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        view.addSubview(textFieldSearchView)
        view.addSubview(collectionView)
        
        textFieldSearchView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(30)
        }
       
        collectionView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(textFieldSearchView.snp.bottom).offset(10)
        }
    }
}

private extension HerousCollectionViewController {
    func getCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            return .tilesSection(tileIndex: 0.33)
        }
    }
    
    func getCollectionDataSource() -> RxCollectionViewSectionedReloadDataSource<HeroSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<HeroSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath] {
                case .normal(let cellModel):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hero.collection.cell", for: indexPath) as? HeroCollectionViewCell
                    else { return UICollectionViewCell() }
                    
                    cell.configure(with: cellModel)
                    return cell
                    
                case .error(_):
                    return UICollectionViewCell()
                    
                case .empty:
                    return UICollectionViewCell()
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
        viewModel.herousCells
            .bind(to: collectionView.rx.items(dataSource: getCollectionDataSource()))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(HeroSectionItem.self)
            .subscribe(onNext: { [weak self] heroCellType in
                if case let .normal(viewModel) = heroCellType {
                    self?.viewModel.selectHero.onNext(viewModel.hero)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .onShowLoadingHud
            .map { [unowned self] in self.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        textFieldSearchView.rx.controlEvent([.editingChanged])
            .asObservable()
            .map { [unowned self] in viewModel.searchTextDidChange(with: textFieldSearchView.text ?? "") }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func setLoadingHud(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
}
