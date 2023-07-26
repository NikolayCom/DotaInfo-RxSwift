import Foundation
import RxRelay
import RxSwift
import RxDataSources
import Models
import UseCases


// MARK: HerousCollectionViewModelInterface

public protocol HerousCollectionViewModelInterface: AnyObject {
    var onShowLoadingHud: Observable<Bool> { get }
    var herousCells: Observable<[HeroSectionModel]> { get }
    
    var selectHero: PublishSubject<Hero> { get }
    
    func loadView()
    func searchTextDidChange(with text: String)
}

// MARK: HerousCollectionViewModel

public class HerousCollectionViewModel {
    public var herousCells: Observable<[HeroSectionModel]> {
        return cells
            .asObservable()
    }
    
    public var onShowLoadingHud: Observable<Bool> {
        return loadingInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    public let selectHero = PublishSubject<Hero>()
    
    private let onShowError = PublishSubject<Any>()
    private let disposeBag = DisposeBag()
    private let appServerClient: AppServerClient
    
    private var herous: [Hero] = []
    
    private let loadingInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[HeroSectionModel]>(value: [])
    
    public init(appServerClient: AppServerClient) {
        self.appServerClient = appServerClient
    }
}

// MARK: HerousCollectionViewModel

extension HerousCollectionViewModel: HerousCollectionViewModelInterface {
    public func loadView() {
        getFriends()
    }
    
    public func searchTextDidChange(with text: String) {
        let matchHerous = !text.isEmpty ? self.herous.filter({ $0.localizedName.lowercased().contains(text.lowercased()) }) : self.herous
        self.acceptCells(with: matchHerous)
    }
}

private extension HerousCollectionViewModel {
    func getFriends() {
        loadingInProgress.accept(true)
        
        appServerClient
            .getHerous()
            .subscribe(
                onNext: { [weak self] herous in
                    self?.herous = herous
                    self?.loadingInProgress.accept(false)
                    self?.acceptCells(with: herous)
                },
                onError: { [weak self] error in
                    self?.loadingInProgress.accept(false)
                    self?.cells.accept([])
                }
            )
            .disposed(by: disposeBag)
    }
    
    func acceptCells(with items: [Hero]) {
        self.cells.accept(
            [
                .force(items: getFilteredHerous(by: .force, herous: items)),
                .dexterity(items: getFilteredHerous(by: .dexterity, herous: items)),
                .intelligence(items: getFilteredHerous(by: .intelligence, herous: items)),
                .universal(items: getFilteredHerous(by: .universal, herous: items)),
            ].filter( { !$0.items.isEmpty })
        )
    }
    
    func getFilteredHerous(by type: HeroSectionModel.Section, herous: [Hero]) -> [HeroSectionItem] {
        return herous
            .filter { $0.primaryAttr == type.rawValue }
            .compactMap { .normal(cellViewModel: .init(id: $0.id, imageUrl: getImageUrl(with: $0.name), name: $0.localizedName, hero: $0)) }
    }
    
    func getImageUrl(with serverName: String) -> String {
        let baseImageUrl = "https://cdn.cloudflare.steamstatic.com/apps/dota2/images/dota_react/heroes/crops/"
        let serverNamePrefix = "npc_dota_hero_"
                
        guard let range = serverName.range(of: serverNamePrefix) else { return "" }
        let heroName = serverName[range.upperBound...]
        
        return "\(baseImageUrl)\(heroName).png"
    }
}
