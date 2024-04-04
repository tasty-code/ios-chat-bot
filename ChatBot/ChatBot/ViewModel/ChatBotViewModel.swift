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
        let chat = RequestChatDTO(messages: [
            Message(role: "system", content: "나는 병신이야"),
            Message(role: "user", content: "집에가고싶어요..")
        ])
        self.chatBotNetwork = ChatBotNetwork(network: Network(NetworkURL.makeURLRequest(type: .chatGPT, chat: chat, httpMethod: .post)!))
    }
    
    struct Input {
        let chatTigger: Observable<Void>
    }
    
    struct Output {
        let resultChat: Observable<Result<ResponseChatDTO, Error>>
    }
    
    func transform(input: Input) -> Output {
        let resultChat = input.chatTigger.flatMapLatest { [unowned self] _ -> Observable<Result<ResponseChatDTO, Error>> in
            self.chatBotNetwork.requestChatBotMessage().map {
                    return .success($0)
                }
                .catchError { error in
                    return Observable.just(.failure(error))
                }
        }
        return Output(resultChat: resultChat)
    }
}
