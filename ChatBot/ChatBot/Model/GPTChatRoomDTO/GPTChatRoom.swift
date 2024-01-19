//
//  GPTChatRoom.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Foundation

extension Model {
    struct GPTChatRoomDTO: Hashable, Identifiable {
        let id: UUID
        let title: String
        
        init(id: UUID = UUID(), title: String) {
            self.id = id
            self.title = title
        }
    }
}

extension Model.GPTChatRoomDTO: Encodable {
    enum CodingKeys: CodingKey {
        case id
        case title
    }
    
    func encode(to encoder: Encoder) throws {
        let container = encoder.container(keyedBy: CodingKeys.self)
        container.
    }
}
