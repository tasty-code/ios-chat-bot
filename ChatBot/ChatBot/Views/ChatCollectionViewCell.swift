//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/16/24.
//

import UIKit

final class ChatCollectionViewCell: UICollectionViewListCell {
    var item: Chat!
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var config = ChatContentConfiguration().updated(for: state)
        config.content = item.message
        config.sender = item.sender
        contentConfiguration = config
    }
}
