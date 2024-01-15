//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by 김경록 on 1/14/24.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    // MARK: - static property

    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    // MARK: - property

    private lazy var chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.backgroundColor = .orange
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = contentView.bounds.width * 0.7
        contentView.addSubview(label)
        return label
    }()
    
    // MARK: - methods

    func setConstraintUserBubble() {
        chatLabel.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            chatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chatLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            chatLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setConstraintAIBubble() {
        chatLabel.backgroundColor = .gray
        NSLayoutConstraint.activate([
            chatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chatLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            chatLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setChatLabelText(to text: String) {
        chatLabel.text = text
    }
}
