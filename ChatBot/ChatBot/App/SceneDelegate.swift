//
//  SceneDelegate.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configure(windowScene)
    }
}

extension SceneDelegate {
    private func configure(_ windowScene: UIWindowScene) {
        let navigationController = DependencyProvider.shared.container.resolve(UINavigationController.self)
        let mainCoordinator = DependencyProvider.shared.container.resolve(MainCoordinator.self)

        mainCoordinator?.start()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
