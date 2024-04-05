//
//  MessageUpdateStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/5/24.
//

import UIKit

struct MessageUpdateStrategy: SnapshotUpdateStrategy {
    func apply(using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>, with chatMessage: ChatMessage, loadingMessage: ChatMessage) {
        snapshot.deleteItems([loadingMessage])
        
        if let last = snapshot.itemIdentifiers.last {
            snapshot.insertItems([chatMessage], afterItem: last)
        }
    }
}
