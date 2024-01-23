//
//  GPTChattingCell.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import UIKit

final class GPTChattingCell: UICollectionViewCell {
    private let chatBubble: UIChatBubbleView = {
        let bubbleView = UIChatBubbleView(emptyWidth: 100, emptyHeight: 50, dotsSpacing: 15, frame: .zero)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        return bubbleView
    }()
    
    private var directionConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(chatBubble)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            chatBubble.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.0),
            chatBubble.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
            chatBubble.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.66),
        ])
    }
    
    func configureCell(to message: GPTMessagable) {
        let direction: UIChatBubbleView.StartDirection = message.role == .user ? .right : .left
        chatBubble.setText(message.content, direction: direction)
        directionConstraint.isActive = false
        if direction == .left {
            directionConstraint = chatBubble.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12.0)
        } else {
            directionConstraint = chatBubble.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12.0)
        }
        directionConstraint.isActive = true
    }
}
