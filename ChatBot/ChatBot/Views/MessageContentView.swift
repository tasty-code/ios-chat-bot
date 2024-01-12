//
//  MessageContentView.swift
//  ChatBot
//
//  Created by 김진웅 on 1/12/24.
//

import UIKit

final class MessageContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            guard let configuration = configuration as? MessageContentConfiguration else { return }
            apply(configuration)
        }
    }
    
    private lazy var chatBubble: ChatBubbleView = {
       let bubble = ChatBubbleView()
        bubble.backgroundColor = .clear
        
        addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    private var constraint = NSLayoutConstraint()
    
    init(configuration: MessageContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        apply(configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            chatBubble.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            chatBubble.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            chatBubble.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.66)
        ])
    }
    
    private func apply(_ configuration: MessageContentConfiguration) {
        guard let message = configuration.message else { return }
        chatBubble.chatLabel.text = message.content
        
        constraint.isActive = false
        switch message.role {
        case .user:
            chatBubble.direction = .right
            constraint = chatBubble.trailingAnchor.constraint(equalTo: trailingAnchor)
        case .system:
            break
        case .assistant:
            chatBubble.direction = .left
            constraint = chatBubble.leadingAnchor.constraint(equalTo: leadingAnchor)
        }
        constraint.isActive = true
    }
}
