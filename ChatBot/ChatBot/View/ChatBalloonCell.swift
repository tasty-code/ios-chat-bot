//
//  ChatBalloonCell.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class ChatBalloonCell: UICollectionViewListCell {
    
    private lazy var chatBalloonView: ChatBalloon = {
        let view = ChatBalloon()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatBalloonCell Init Error")
    }
    
    private func configure() {
        self.contentView.addSubview(chatBalloonView)
        
        NSLayoutConstraint.activate([
            chatBalloonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            chatBalloonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            chatBalloonView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
        ])
    }
    
    func setLabelText(text: String) {
        chatBalloonView.text = text
    }
    
    func setDirection(direction: Direction) {
        chatBalloonView.direction = direction
        if direction == .right {
            NSLayoutConstraint.activate([
                chatBalloonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            ])
            chatBalloonView.leftOrRight(direction: .right)
        } else {
            NSLayoutConstraint.activate([
                chatBalloonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ])
            chatBalloonView.leftOrRight(direction: .left)
        }
    }
}
