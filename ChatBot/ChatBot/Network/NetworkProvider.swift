//
//  NetworkProvider.swift
//  ChatBot
//
//  Created by Matthew on 4/4/24.
//

import Foundation

final class NetworkProvider {
    func makeChatNetwork() -> ChatBotNetwork {
        let network = Network<ResponseChatDTO>()
        return ChatBotNetwork(network: network)
    }
}
