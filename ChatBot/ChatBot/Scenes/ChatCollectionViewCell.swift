//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/2/24.
//

import UIKit

final class ChatCollectionViewCell: UICollectionViewCell {
    static let className: String = String(describing: ChatCollectionViewCell.self)
    
    private let chatBubbleView = ChatBubbleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCollectionViewCell {
    private func configure() {
        self.addSubview(chatBubbleView)
        
        chatBubbleView.snp.makeConstraints { 
            $0.edges.equalTo(self.snp.edges)
        }
    }
}

extension ChatCollectionViewCell {
    func text(_ string: String, isUser: Bool) {
        chatBubbleView.setText(string)
        chatBubbleView.setUser(isUser)
    }
}
