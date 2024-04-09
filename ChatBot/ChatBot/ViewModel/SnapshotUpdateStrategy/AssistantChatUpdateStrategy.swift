//
//  AssistantChatUpdateStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/5/24.
//

import UIKit

struct AssistantChatUpdateStrategy: SnapshotUpdateStrategy {
    func apply(using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>, with chatMessage: ChatMessage, loadingMessage: ChatMessage) {
        snapshot.insertItems([chatMessage], beforeItem: loadingMessage)
        snapshot.deleteItems([loadingMessage])        
    }
}
