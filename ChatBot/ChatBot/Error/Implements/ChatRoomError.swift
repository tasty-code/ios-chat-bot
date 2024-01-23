//
//  ChatRoomError.swift
//  ChatBot
//
//  Created by 김준성 on 1/17/24.
//

import Foundation

extension GPTError {
    enum ChatRoomError: Error {
        case emptyUserComment
        case emptyGPTReply
        case noRoomName
    }
}

extension GPTError.ChatRoomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyUserComment:
            return "내용을 입력해주세요."
        case .emptyGPTReply:
            return "챗봇에 응답이 없습니다."
        case .noRoomName:
            return "방 제목을 입력해주세요."
        }
    }
}
