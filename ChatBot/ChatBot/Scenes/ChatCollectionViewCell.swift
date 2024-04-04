//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by Kim EenSung on 4/2/24.
//

import UIKit

/// 콜렉션뷰셀
final class ChatCollectionViewCell: UICollectionViewCell {
    static let className: String = String(describing: ChatCollectionViewCell.self)
    
    private let chatBubbleView = ChatBubbleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension ChatCollectionViewCell {
    private func configureUI() {
        self.addSubview(chatBubbleView)
        
        chatBubbleView.snp.makeConstraints { 
            $0.edges.equalTo(self.snp.edges)
        }
    }
}

// MARK: - Public Methods
extension ChatCollectionViewCell {
    func text(_ string: String, isUser: Bool) {
        chatBubbleView.setText(string)
        chatBubbleView.setUser(isUser)
        
        chatBubbleView.snp.remakeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.width.lessThanOrEqualTo(self.snp.width).multipliedBy(0.70)
            _ = isUser ? $0.trailing.equalTo(self.snp.trailing) : $0.leading.equalTo(self.snp.leading)
        }
    }
}
