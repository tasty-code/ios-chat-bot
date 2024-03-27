//
//  UseCase.swift
//  ChatBot
//
//  Created by ㅣ on 3/26/24.
//

import Foundation
import RxSwift

struct SendChatMessageUseCase {
    func execute(model: String, content: String) -> Observable<[ChatMessageEntity]> {
        return .empty()
    }
}
