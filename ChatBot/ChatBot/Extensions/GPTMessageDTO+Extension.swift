//
//  GPTMessageDTO+Extension.swift
//  ChatBot
//
//  Created by 김진웅 on 1/13/24.
//

import Foundation

extension GPTMessageDTO: Hashable {
    static func == (lhs: GPTMessageDTO, rhs: GPTMessageDTO) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }
}
