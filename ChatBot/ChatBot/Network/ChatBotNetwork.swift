//
//  ChatBotNetwork.swift
//  ChatBot
//
//  Created by Matthew on 4/4/24.
//

import Foundation
import RxSwift

final class ChatBotNetwork {
    private let network: Network<ResponseChatDTO>
    
    init(network: Network<ResponseChatDTO>) {
        self.network = network
    }
    
    func requestChatBotMessage() -> Observable<ResponseChatDTO> {
        return network.fetchData()
    }
}

