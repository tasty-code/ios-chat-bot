//
//  DependencyUnitTests.swift
//  ChatBotUnitTests
//
//  Created by ㅣ on 3/27/24.
//

import XCTest
@testable import ChatBot

final class DependencyUnitTests: BaseTestCase {
    var sut: DependencyProvider!
    
    override func setUp() {
        super.setUp()
        sut = DependencyProvider.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

extension DependencyUnitTests {
    func test_givenDependencyProvider_whenResolvingMainCoordinator_thenMainCoordinatorIsResolved() {
        var mainCoordinator: MainCoordinator!
        
        when {
            mainCoordinator = sut.resolve(MainCoordinator.self)
        }
        
        then {
            XCTAssertNotNil(mainCoordinator)
        }
    }
    
    func test_givenDependencyProvider_whenResolvingNewUserCoordinator_thenNewUserCoordinatorIsResolved() {
        var newUserCoordinator: NewUserCoordinator!
        
        when {
            newUserCoordinator = sut.resolve(NewUserCoordinator.self)
        }
        
        then {
            XCTAssertNotNil(newUserCoordinator)
        }
    }
    
    func test_givenDependencyProvider_whenResolvingReturningUserCoordinator_thenReturningUserCoordinatorIsResolved() {
        var returningUserCoordinator: ReturningUserCoordinator!
        
        when {
            returningUserCoordinator = sut.resolve(ReturningUserCoordinator.self)
        }
        
        then {
            XCTAssertNotNil(returningUserCoordinator)
        }
    }
    
    func test_givenDependencyProvider_whenResolvingViewController_thenViewControllerIsResolved() {
        var viewController: ViewController!
        
        when {
            viewController = sut.resolve(ViewController.self)
        }
        
        then {
            XCTAssertNotNil(viewController)
        }
    }
}
