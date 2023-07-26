import RxSwift
import Core
import Models

public class HeroCoordinator: BaseCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    public override func start() -> Observable<Void> {
        let viewController = rootViewController as! HerousCollectionViewController
        let viewModel = viewController.viewModel
        
        viewModel.selectHero
            .map { [unowned self] hero in self.coordinateToHeroInfo(with: hero) }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    // MARK: - Coordination
    
    private func coordinateToHeroInfo(with model: Hero) -> Observable<Void> {
        let heroInfoCoordinator = HeroInfoCoordinator(rootViewController: rootViewController)
        heroInfoCoordinator.model = model
        
        return coordinate(to: heroInfoCoordinator)
    }
}
