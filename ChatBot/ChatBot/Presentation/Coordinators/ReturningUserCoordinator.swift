//
//  ReturningUserCoordinator.swift
//  ChatBot
//
//  Created by ㅣ on 3/27/24.
//

import UIKit

final class ReturningUserCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
}
