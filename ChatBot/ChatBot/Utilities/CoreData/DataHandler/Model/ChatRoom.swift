//
//  ChatRoom.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import Foundation

struct ChatRoom {
    let uuid: UUID
    var title: String
    var date: Date
    
    init(uuid: UUID = UUID(), title: String, date: Date = Date()) {
        self.uuid = uuid
        self.title = title
        self.date = date
    }
}

extension ChatRoom: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.date == rhs.date
    }
}
