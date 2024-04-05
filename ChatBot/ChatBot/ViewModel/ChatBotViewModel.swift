//
//  ChatManager.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/27/24.
//

import Foundation
import RxSwift

final class ChatBotViewModel {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    struct Input {
        let chatTigger: Observable<Message>
    }
    
    struct Output {
        let resultChat: Observable<Result<ResponseChatDTO, Error>>
    }
    
    func transform(input: Input) -> Output {
        let resultChat = input.chatTigger.flatMapLatest { [unowned self] message -> Observable<Result<ResponseChatDTO, Error>> in
            return self.chatRepository.requestChatResultData(message: message)
        }
        return Output(resultChat: resultChat)
    }
}
