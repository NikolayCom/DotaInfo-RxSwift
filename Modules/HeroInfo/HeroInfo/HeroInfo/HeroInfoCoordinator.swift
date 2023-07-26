import RxSwift
import Core
import Models
import UseCases

class HeroInfoCoordinator: BaseCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    var model: Hero?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        guard let model else { return Observable.never() }
        
        let viewModel = HeroInfoViewModel(data: model, appServerClient: AppServerClient())
        let viewController = HeroInfoViewController(viewModel: viewModel)
        
        rootViewController.present(viewController, animated: true)
        
        return Observable.never()
    }
    
    // MARK: - Coordination
}
