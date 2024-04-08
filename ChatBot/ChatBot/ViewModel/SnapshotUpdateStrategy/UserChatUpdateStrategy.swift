//
//  UserChatUpdateStrategy.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/5/24.
//

import UIKit

struct UserChatUpdateStrategy: SnapshotUpdateStrategy {
    func apply(using snapshot: inout NSDiffableDataSourceSnapshot<ChatViewModel.Section, ChatMessage>, with chatMessage: ChatMessage, loadingMessage: ChatMessage) {
        if let last = snapshot.itemIdentifiers.last {
            snapshot.insertItems([chatMessage, loadingMessage], afterItem: last)
        } else {
            snapshot.appendItems([chatMessage, loadingMessage])
        }
    }
}
