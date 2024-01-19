//
//  BubbleCell.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/15.
//

import UIKit

class BubbleCell: UICollectionViewCell {
    static let identifier = "BubbleCell"
    
    var role: Role?
    private let bubbleView: UIView = UIView()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let loadingView: UIView = LoadingView()
    
    private lazy var bubbleTailView: BubbleTailView = {
        let color: UIColor = role == .user ? .systemYellow : .systemMint
        let bubbleTailView = BubbleTailView(color: color)
        return bubbleTailView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBubbleCell(message: Message) {
        role = Role(rawValue: message.role)
        textLabel.text = message.content
        bubbleView.backgroundColor = role == Role.user ? .systemYellow : .systemMint
        textLabel.textAlignment = role == Role.user ? .right : .left
        
        if role == .assistant {
            bubbleView.addSubview(loadingView)
            loadingView.isHidden = message.content == "" ? false : true
        }
        
        bubbleView.addSubview(textLabel)
        bubbleView.addSubview(bubbleTailView)
        contentView.addSubview(bubbleView)

        configuration()
    }
    
    private func configuration() {
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleTailView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            textLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),
            textLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            
            bubbleTailView.widthAnchor.constraint(equalToConstant: 12),
            bubbleTailView.heightAnchor.constraint(equalToConstant: 12),
            bubbleTailView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
        ])
        
        let loadingBubbleSize = [bubbleView.widthAnchor.constraint(equalToConstant: 80),
                                 bubbleView.heightAnchor.constraint(equalToConstant: 40)]
        
        let commonBubbleSize = [bubbleView.widthAnchor.constraint(greaterThanOrEqualTo: textLabel.widthAnchor, constant: 20),
                                bubbleView.heightAnchor.constraint(equalTo: textLabel.heightAnchor, constant: 20),
                                bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)]
        
        if role == .user {
            NSLayoutConstraint.activate(commonBubbleSize)
            NSLayoutConstraint.activate([
                bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                bubbleTailView.leadingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                bubbleTailView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -12),
                
                loadingView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
                loadingView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
                loadingView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
                loadingView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            ])
            
            bubbleTailView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
            
            NSLayoutConstraint.deactivate(textLabel.text == "" ? commonBubbleSize : loadingBubbleSize)
            NSLayoutConstraint.activate(textLabel.text == "" ? loadingBubbleSize : commonBubbleSize)
        }
    }
}
