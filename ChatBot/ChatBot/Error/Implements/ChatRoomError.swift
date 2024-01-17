//
//  ChatRoomError.swift
//  ChatBot
//
//  Created by 김준성 on 1/17/24.
//

import Foundation

extension GPTError {
    enum ChatRoomError: Error {
        case emptyContent
    }
}

extension GPTError.ChatRoomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyContent:
            return "내용을 입력해주세요."
        }
    }
}
