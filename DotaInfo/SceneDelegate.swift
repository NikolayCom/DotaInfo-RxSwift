//
//  SceneDelegate.swift
//  DotaInfo
//
//  Created by Nikolay Pivnik on 8.07.23.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private let disposeBag = DisposeBag()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        configureController()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

private extension SceneDelegate {
    func configureController() {
        appCoordinator = AppCoordinator(window: window!)
        
        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        // let viewModel = HerousCollectionViewModel(appServerClient: AppServerClient())
        // let viewController = HerousCollectionViewController(viewModel: viewModel)
        
        // window?.rootViewController = viewController
        // window?.makeKeyAndVisible()
    }
}
