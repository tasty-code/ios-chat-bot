//
//  MainCoordinator.swift
//  ChatBot
//
//  Created by ㅣ on 3/27/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension MainCoordinator {
    func start() {
        if isFirstTimeUser() {
            let newUserCoordinator = NewUserCoordinator(navigationController: navigationController)
            addChildCoordinator(newUserCoordinator)
            newUserCoordinator.start()
        } else {
            let returningUserCoordinator = ReturningUserCoordinator(navigationController: navigationController)
            addChildCoordinator(returningUserCoordinator)
            returningUserCoordinator.start()
        }
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { return }
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    private func isFirstTimeUser() -> Bool {
        // 첫 방문자인지 체크하기 추후 구현
        return true
    }
}
