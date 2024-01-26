//
//  RightBalloonCell.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/25.
//

import UIKit

final class RightBalloonCell: UICollectionViewListCell {
    
    private lazy var chatBalloonView: ChatBalloon = ChatBalloon()
    
    private var chatBallonViewConstraint = [NSLayoutConstraint]()
    private var contentVeiwHeightConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatBalloonCell Init Error")
    }
    
    private func configure() {
        self.contentView.addSubview(chatBalloonView)
        
        chatBallonViewConstraint = [
            chatBalloonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            chatBalloonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            chatBalloonView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            chatBalloonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(chatBallonViewConstraint)
    }
    
    func makeBalloon() {
        chatBalloonView.setDirection(direction: .right)
        chatBalloonView.rightBalloon()
    }
    
    func setLabelText(text: String) {
        chatBalloonView.text = text
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        chatBalloonView.text = ""
    }
}
