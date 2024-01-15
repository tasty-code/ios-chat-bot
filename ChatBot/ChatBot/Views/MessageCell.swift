//
//  MessageCell.swift
//  ChatBot
//
//  Created by 김진웅 on 1/12/24.
//

import UIKit

final class MessageCell: UICollectionViewCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        let configuration = MessageContentConfiguration().updated(for: state)
        contentConfiguration = configuration
    }
}
