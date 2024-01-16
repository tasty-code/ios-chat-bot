//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/16/24.
//

import UIKit

final class ChatCollectionViewCell: UICollectionViewListCell {
    var item: ChatMessage!
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var config = ChatContentConfiguration().updated(for: state)
        config.content = item.message
        contentConfiguration = config
    }
}
