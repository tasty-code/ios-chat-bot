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
    let messageTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10.0
        $0.layer.masksToBounds = false
        $0.isEditable = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        self.addSubview(messageTextView)
        
        messageTextView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
    }
    
    func setupMessageText(message: Message) {
        messageTextView.text = message.content
    }

}

