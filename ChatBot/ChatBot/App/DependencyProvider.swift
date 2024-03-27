//
//  DIContainer.swift
//  ChatBot
//
//  Created by ㅣ on 3/27/24.
//

import UIKit
import Swinject

final class DependencyProvider {
    static let shared = DependencyProvider()
    let container = Container()
    
    private init() { registerDependencies() }
}

extension DependencyProvider {
    
    private func registerDependencies() {
        let navigationController = UINavigationController()
        
        // MARK: - Register Coordinator
        container.register(UINavigationController.self) { resolver in
            return navigationController
        }
        
        container.register(MainCoordinator.self) { resolver in
            let navigationController = resolver.resolve(UINavigationController.self)!
            return MainCoordinator(navigationController: navigationController)
        }
            
        container.register(NewUserCoordinator.self) { resolver in
            let navigationController = resolver.resolve(UINavigationController.self)!
            return NewUserCoordinator(navigationController: navigationController)
        }
        
        container.register(ReturningUserCoordinator.self) { resolver in
            let navigationController = resolver.resolve(UINavigationController.self)!
            return ReturningUserCoordinator(navigationController: navigationController)
        }
        
        // MARK: - Register ViewController
        container.register(ViewController.self) { resolver in
            let coordinator = resolver.resolve(MainCoordinator.self)!
            let viewController = ViewController(coordinator: coordinator)
            return viewController
        }

    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = container.resolve(serviceType) else {
            fatalError("경고: \(serviceType) 를 찾을 수 없습니다.")
        }
        return service
    }
}
