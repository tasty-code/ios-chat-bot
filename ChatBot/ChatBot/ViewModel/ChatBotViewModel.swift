//
//  ChatManager.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/27/24.
//

import Foundation
import RxSwift

final class ChatBotViewModel {
    private let chatBotNetwork: ChatBotNetwork
    
    init() {
        let provider = NetworkProvider()
        self.chatBotNetwork = provider.makeChatNetwork()
    }
    
    struct Input {
        let chatTigger: Observable<Message>
    }
    
    struct Output {
        let resultChat: Observable<Result<ResponseChatDTO, Error>>
    }
    
    func transform(input: Input) -> Output {
        let resultChat = input.chatTigger.flatMapLatest { [unowned self] message -> Observable<Result<ResponseChatDTO, Error>> in
            self.chatBotNetwork.requestChatBotMessage(message: message).map {
                    return .success($0)
                }
                .catchError { error in
                    return Observable.just(.failure(error))
                }
        }
        return Output(resultChat: resultChat)
    }
}
