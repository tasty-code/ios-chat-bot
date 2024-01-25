//
//  BubbleCell.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/15.
//

import UIKit

final class BubbleCell: UICollectionViewCell {
    
    var role: Role?
    
    private let bubbleView: UIView = UIView()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var loadingView: LoadingView = LoadingView()
    
    private lazy var bubbleTailView: BubbleTailView = BubbleTailView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBubbleCell(message: Message) {
        role = Role(rawValue: message.role)
        textLabel.text = message.content
        
        let isUserChat = role == Role.user
        
        bubbleView.backgroundColor = isUserChat ? .systemYellow : .systemMint
        bubbleTailView.backgroundColor = isUserChat ? .systemYellow : .systemMint
        textLabel.textAlignment = isUserChat ? .right : .left
        
        loadingView.isHidden = true
        bubbleTailView.transform = .identity
        
        if !isUserChat && message.content.isEmpty {
            bubbleView.addSubview(loadingView)
            loadingView.isHidden = false
        } else if !isUserChat {
            loadingView.isHidden = true
        }
        
        bubbleView.addSubview(textLabel)
        bubbleView.addSubview(bubbleTailView)
        contentView.addSubview(bubbleView)

        configuration()
    }
    
    private var userBubbleConstraints: [NSLayoutConstraint]?
    private var assistantConstraints: [NSLayoutConstraint]?
    private var textLabelConstraints: [NSLayoutConstraint]?
    private var loadingConstraints: [NSLayoutConstraint]?
    
    private func configuration() {
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleTailView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        userBubbleConstraints?.forEach { $0.isActive = false }
        assistantConstraints?.forEach { $0.isActive = false }
        textLabelConstraints?.forEach { $0.isActive = false }
        loadingConstraints?.forEach { $0.isActive = false }        
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            
            bubbleTailView.widthAnchor.constraint(equalToConstant: 12),
            bubbleTailView.heightAnchor.constraint(equalToConstant: 12),
            bubbleTailView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
        ])
        
        userBubbleConstraints = [bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                                 bubbleTailView.leadingAnchor.constraint(equalTo: bubbleView.trailingAnchor)]
        
        assistantConstraints = [bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                                bubbleTailView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -12)]
        
        textLabelConstraints = [textLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
                                textLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
                                textLabel.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, constant: -20),
                                textLabel.heightAnchor.constraint(lessThanOrEqualTo: bubbleView.heightAnchor, constant: -20)]
        
        loadingConstraints = [loadingView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
                              loadingView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
                              loadingView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                              loadingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
                              loadingView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor),
                              loadingView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor)]
        
        if role == .user {
            bubbleTailView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
            assistantConstraints?.forEach { $0.isActive = false }
            userBubbleConstraints?.forEach { $0.isActive = true }
        } else {
            userBubbleConstraints?.forEach { $0.isActive = false }
            assistantConstraints?.forEach { $0.isActive = true }
        }
        
        if textLabel.text == "" {
            textLabelConstraints?.forEach { $0.isActive = false }
            loadingConstraints?.forEach { $0.isActive = true }
        } else {
            loadingConstraints?.forEach { $0.isActive = false }
            textLabelConstraints?.forEach { $0.isActive = true }
        }
    }
}
