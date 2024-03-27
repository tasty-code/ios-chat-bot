//
//  NewUserCoordinator.swift
//  ChatBot
//
//  Created by ㅣ on 3/27/24.
//

import UIKit

final class NewUserCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = DependencyProvider.shared.resolve(ViewController.self)
        navigationController.pushViewController(viewController, animated: false)
    }
}
