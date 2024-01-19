//
//  MockChatRoomList.swift
//  ChatBotTests
//
//  Created by 김준성 on 1/19/24.
//

import Foundation

@testable import ChatBot

struct MockChatRoom {
    static let mockChatRoom = Model.GPTChatRoomDTO(id: UUID(uuidString: "8D273386-6429-4816-ACF3-1ADB912C1455")!, title: "테스트용 채팅방", recentChatDate: Date(unixTimeStamp: 222222))
}
