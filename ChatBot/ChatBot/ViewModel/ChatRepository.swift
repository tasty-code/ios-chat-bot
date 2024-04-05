//
//  Repository.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation
import RxSwift

struct ChatRepository {
    private let chatBotNetwork: ChatBotNetwork
    
    init(provider: NetworkProvider) {
        self.chatBotNetwork = provider.makeChatNetwork()
    }
    
    func requestChatResultData(message: Message) -> Observable<ResponseChatDTO> {
        self.chatBotNetwork.requestChatBotMessage(message: message).map {
            return $0
        }
    }
}
