//
//  UserChatUpdateStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/5/24.
//

import UIKit

struct UserChatUpdateStrategy: SnapshotUpdateStrategy {
    func apply(using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>, with chatMessage: ChatMessage, loadingMessage: ChatMessage) {
        guard let last = snapshot.itemIdentifiers.last else {
            snapshot.appendItems([chatMessage, loadingMessage])
            return
        }
        snapshot.insertItems([chatMessage, loadingMessage], afterItem: last)
    }
}
