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
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            chatBubble.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            chatBubble.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            chatBubble.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.66)
        ])
    }
    
    private func apply(_ configuration: MessageContentConfiguration) {
        guard let message = configuration.message
        else {
            return
        }
        chatBubble.chatLabel.text = message.content
        
        constraint.isActive = false
        switch message.role {
        case .user:
            chatBubble.direction = .right
            constraint = chatBubble.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        case .system:
            break
        case .assistant:
            chatBubble.direction = .left
            constraint = chatBubble.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        }
        constraint.isActive = true
    }
}
