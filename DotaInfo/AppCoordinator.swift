import RxSwift
// import ReactiveCoordinator

class AppCoordinator: BaseCoordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = HerousCollectionViewModel(appServerClient: AppServerClient())
        let viewController = HerousCollectionViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let heroCoordinator = HeroCoordinator(rootViewController: navigationController.topViewController!)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinate(to: heroCoordinator)
    }
}
