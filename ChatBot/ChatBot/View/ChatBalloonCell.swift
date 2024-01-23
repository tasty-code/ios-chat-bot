//
//  ChatBalloonCell.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class ChatBalloonCell: UICollectionViewListCell {
    
    private lazy var chatBalloonView: ChatBalloon = ChatBalloon()
    private lazy var loadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
    
    private var balloonDirectionConstraint = NSLayoutConstraint()
    private var loadingViewConstraint = [NSLayoutConstraint]()
    private var chatBallonViewConstraint = [NSLayoutConstraint]()
    private var contentVeiwHeightConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatBalloonCell Init Error")
    }
    
    private func configure() {
        self.contentView.addSubview(chatBalloonView)
        self.contentView.addSubview(loadingView)
        
        contentVeiwHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 60)
        contentVeiwHeightConstraint.priority = .defaultHigh
        loadingViewConstraint = [
            contentVeiwHeightConstraint,
            loadingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ]
        
        chatBallonViewConstraint = [
            chatBalloonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            chatBalloonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            chatBalloonView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
        ]
        
        NSLayoutConstraint.activate(chatBallonViewConstraint)
    }
    
    func setLabelText(text: String) {
        chatBalloonView.text = text
    }
 
    func setDirection(direction: Direction) {
        
        chatBalloonView.setDirection(direction: direction)
        balloonDirectionConstraint.isActive = false
        chatBalloonView.leftOrRight(direction: direction)
        
        if direction == .right {
            loadingView.isHidden = true
            NSLayoutConstraint.deactivate(loadingViewConstraint)
            
            chatBalloonView.emptyLabelConstraintIsActive(bool: false)
            chatBalloonView.commonLabelConstraintIsActive(bool: true)
            balloonDirectionConstraint = chatBalloonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        } else {
            balloonDirectionConstraint = chatBalloonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            
            if chatBalloonView.text != "" {
                loadingView.isHidden = true
                NSLayoutConstraint.deactivate(loadingViewConstraint)
                
                chatBalloonView.emptyLabelConstraintIsActive(bool: false)
                chatBalloonView.commonLabelConstraintIsActive(bool: true)
            } else {
                loadingView.isHidden = false
                NSLayoutConstraint.activate(loadingViewConstraint)
                
                chatBalloonView.emptyLabelConstraintIsActive(bool: true)

                loadingView.moveCircle()
            }
        }
        balloonDirectionConstraint.isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chatBalloonView.leftLabelConstraintIsActive(bool: false)
        chatBalloonView.rightLabelConstraintIsActive(bool: false)
        chatBalloonView.emptyLabelConstraintIsActive(bool: false)
        chatBalloonView.commonLabelConstraintIsActive(bool: false)
    }
}
