//
//  ChatBotView.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 4/9/24.
//

import UIKit
import Then
import SnapKit

final class ChatBotMessageCell: UICollectionViewListCell {
    private let userBubbleView = UserBubbleView()
    private let systemBubbleView = SystemBubbleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
        setupUserConstraints()
        setupSystemConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Method
extension ChatBotMessageCell {
    func setupMessageText(message: Message, type: String) {
        switch type {
        case "user":
            self.configureUser(text: message.content)
        case "assistant":
            self.configureSystem(text: message.content)
        default:
            break
        }
    }
}

// MARK: - Private Method
private extension ChatBotMessageCell {
    func setupConstraint() {
        self.contentView.addSubview(userBubbleView)
        self.contentView.addSubview(systemBubbleView)
    }
    
    func configureUser(text: String) {
        systemBubbleView.isHidden = true
        userBubbleView.isHidden = false
        userBubbleView.configureMessage(text: text)
    }
    
    func configureSystem(text: String) {
        systemBubbleView.isHidden = false
        userBubbleView.isHidden = true
        systemBubbleView.configureMessage(text: text)
    }
    
    
    func setupUserConstraints() {
        userBubbleView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setupSystemConstraints() {
        systemBubbleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
