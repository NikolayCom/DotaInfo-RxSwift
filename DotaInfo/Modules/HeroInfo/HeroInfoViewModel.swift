import Foundation
import RxSwift
import RxRelay


protocol HeroInfoViewModelInterface: AnyObject {
    var onShowLoadingHud: Observable<Bool> { get }
    var collectionCells: Observable<[HeroInfoSectionModel]> { get }
    var headerInfo: Observable<Hero> { get }
    
    func loadView()
}

class HeroInfoViewModel {
    var onShowLoadingHud: Observable<Bool> {
        return loadingInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    var collectionCells: Observable<[HeroInfoSectionModel]> {
        return cells
            .asObservable()
    }
    
    var headerInfo: Observable<Hero> {
        return data
            .asObservable()
    }
    
    private let appServerClient: AppServerClient
    private let disposeBag = DisposeBag()
    
    private let data: BehaviorRelay<Hero>
    private let loadingInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[HeroInfoSectionModel]>(value: [])
    
    init(data: Hero, appServerClient: AppServerClient) {
        self.data = BehaviorRelay(value: data)
        self.appServerClient = appServerClient
    }
}

extension HeroInfoViewModel: HeroInfoViewModelInterface {
    func loadView() {
        loadingInProgress.accept(true)

        appServerClient.getPopularItems(for: data.value.id)
            .subscribe(
                onNext: { [weak self] items in
                    self?.loadingInProgress.accept(false)
                    self?.configureCells(with: items)
                },
                onError: { [weak self] error in
                    self?.loadingInProgress.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func configureCells(with items: SortedHeroItems) {
        self.cells.accept(
            [
                .statistic(items: [
                    .statistic(cellViewModel: .init(description: "Strength", title: "\(data.value.baseStrenght) +\(data.value.strenghtGain)", imageName: "hero_strength")),
                    .statistic(cellViewModel: .init(description: "Agility", title:"\(data.value.baseAgility) +\(data.value.agilityGain)", imageName: "hero_agility")),
                    .statistic(cellViewModel: .init(description: "Intelligence", title: "\(data.value.baseIntelligence) +\(data.value.intelligenceGain)", imageName: "hero_intelligence"))
                ]),
                .startGame(items: items.startGame.map { .items(cellViewModel: .init(id: $0.id, name: $0.localizedName, image: $0.image)) } ),
                .earlyGame(items: items.earlyGame.map { .items(cellViewModel: .init(id: $0.id, name: $0.localizedName, image: $0.image)) } ),
                .midGame(items: items.midGame.map { .items(cellViewModel: .init(id: $0.id, name: $0.localizedName, image: $0.image)) } ),
                .lateGame(items: items.lateGame.map { .items(cellViewModel: .init(id: $0.id, name: $0.localizedName, image: $0.image)) } )
            ]
        )
    }
}
