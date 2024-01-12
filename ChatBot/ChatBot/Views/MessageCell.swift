//
//  MessageCell.swift
//  ChatBot
//
//  Created by 김진웅 on 1/12/24.
//

import UIKit

final class MessageCell: UICollectionViewListCell {
    var message: GPTMessageable?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var configuration = MessageContentConfiguration().updated(for: state)
        
        configuration.message = message
    }
}
