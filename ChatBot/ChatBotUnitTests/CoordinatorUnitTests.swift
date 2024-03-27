//
//  CoordinatorUnitTests.swift
//  ChatBotUnitTests
//
//  Created by ㅣ on 3/27/24.
//

import XCTest
@testable import ChatBot

final class CoordinatorUnitTests: BaseTestCase {
    var sut: MainCoordinator!
    var navigationController: UINavigationController!
    var isFirstTimeUser: Bool!

    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        sut = MainCoordinator(navigationController: navigationController)
    }
    
    override func tearDown() {
        sut = nil
        navigationController = nil
        super.tearDown()
    }
}

extension CoordinatorUnitTests {
    func test_givenFirstTimeUser_whenStart_thenPushNewUserCoordinator() {
        given {
            isFirstTimeUser = true
        }
        
        when {
            if isFirstTimeUser { sut.start() }
        }
        
        then {
            XCTAssertTrue(sut.childCoordinators.contains { $0 is NewUserCoordinator })
        }
    }
}
