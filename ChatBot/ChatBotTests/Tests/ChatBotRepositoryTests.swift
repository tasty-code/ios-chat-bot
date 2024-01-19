//
//  ChatBotRepositoryTests.swift
//  ChatBotTests
//
//  Created by 김준성 on 1/19/24.
//

import XCTest

@testable import ChatBot

final class ChatBotRepositoryTests: XCTestCase {
    var chatRoomRepository: ChatRoomRepositable!
    
    override func setUpWithError() throws {
        chatRoomRepository = Repository.CoreDataChatRoomRepository()
    }
    
    override func tearDownWithError() throws {
        chatRoomRepository = nil
    }
    
    func test_ChatRoomDTO를_넣으면_에러_없이_저장이_된다() {
        do {
            try chatRoomRepository.storeChatRoom(MockChatRoom.mockChatRoom)
            XCTAssertEqual(true, true)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_ChatRoomDTO를_에러_없이_추출해낸다() {
        let chatRoomList = try? chatRoomRepository.fetchChatRoomList()
        XCTAssertNotNil(chatRoomList)
    }
    
    func test_ChatRoomDTO를_에러_없이_삭제한다() {
        let chatRoomDTO = MockChatRoom.mockChatRoom
        
        do {
            try chatRoomRepository.removeChatRoom(chatRoomDTO)
            XCTAssertEqual(true, true)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
