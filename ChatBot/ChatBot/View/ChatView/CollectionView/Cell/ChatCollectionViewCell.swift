//
//  ChatCollectionViewCell.swift
//  ChatBot
//
//  Created by 김경록 on 1/14/24.
//

import UIKit

final class ChatCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properties

    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    private var chatBotBubbleConstarint: [NSLayoutConstraint] = []
    private var userBubbleConstraint: [NSLayoutConstraint] = []
    private var animationConstraint: [NSLayoutConstraint] = []
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 4
        view.addSubview(chatLabel)
        view.addSubview(bubbleTail)
        
        return view
    }()
    
    private lazy var loadingView: LoadingAnimationView = {
        var view = LoadingAnimationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var bubbleTail: ChatBubbleTail = {
        var tail = ChatBubbleTail(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
        tail.translatesAutoresizingMaskIntoConstraints = false
        tail.backgroundColor = .clear
        
        return tail
    }()
    
    private lazy var chatLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: internal methods

extension ChatCollectionViewCell {
    func configureBubbles(with material: Message) {
        let role = material.role
        let content = material.content
        chatLabel.text = content
        
        switch role {
        case RequestBodyConstant.indicator :
            configureChatbotBubble(isFetching: true)
        case RequestBodyConstant.userRole :
            configureUserBubble()
        case RequestBodyConstant.AIRole :
            configureChatbotBubble(isFetching: false)
        default:
            break
        }
    }
}

//MARK: - private methods

extension ChatCollectionViewCell {
    private func configure() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor ),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8),
            
            chatLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            chatLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            chatLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            chatLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            bubbleTail.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bubbleTail.widthAnchor.constraint(equalToConstant: 15),
            bubbleTail.heightAnchor.constraint(equalToConstant: 10),
            
            loadingView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//MARK: override Methods

extension ChatCollectionViewCell {
    
    override func layoutSubviews() {
        loadingView.runSpinner()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        NSLayoutConstraint.deactivate(chatBotBubbleConstarint + userBubbleConstraint + animationConstraint)
        layoutIfNeeded()
    }
}

//MARK: - chatBubbleConfigure

extension ChatCollectionViewCell {
    private func configureChatbotBubble(isFetching: Bool) {
        chatBotBubbleConstarint = [
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bubbleTail.trailingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 3)
        ]
        containerView.backgroundColor = .darkGray
        bubbleTail.color = .darkGray
        bubbleTail.transform = CGAffineTransform(scaleX: -1, y: 1)
        chatLabel.textColor = .white
        
        if isFetching {
            showAnimationView()
        } else {
            loadingView.removeFromSuperview()
        }
        
        NSLayoutConstraint.activate(chatBotBubbleConstarint)
    }
    
    private func configureUserBubble() {
        userBubbleConstraint = [
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bubbleTail.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3)
        ]
        containerView.backgroundColor = .systemYellow
        chatLabel.textColor = .black
        bubbleTail.transform = CGAffineTransform(scaleX: 1, y: 1)
        bubbleTail.color = .systemYellow
        loadingView.removeFromSuperview()
        
        NSLayoutConstraint.activate(userBubbleConstraint)
    }
    
    private func showAnimationView() {
        containerView.addSubview(loadingView)
        animationConstraint = [
            loadingView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            loadingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            loadingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            loadingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(animationConstraint)
    }
}
