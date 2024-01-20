//
//  ChatBalloonCell.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class ChatBalloonCell: UICollectionViewListCell {
    
    private lazy var chatBalloonView: ChatBalloon = ChatBalloon()
    var count = 0
    
    private let loadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44)))
    
    private var balloonConstraint = NSLayoutConstraint()
    private var loadingViewConstraint = [NSLayoutConstraint]()
    private var chatBallonViewConstraint = [NSLayoutConstraint]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatBalloonCell Init Error")
    }
    
    private func configure() {
        self.contentView.addSubview(chatBalloonView)
        
        loadingViewConstraint = [
            loadingView.topAnchor.constraint(equalTo: self.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
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
        chatBalloonView.direction = direction
        balloonConstraint.isActive = false
        if direction == .right {
            chatBalloonView.emptyLabelConstraintIsActive(bool: false)
            chatBalloonView.rightLabelConstraintIsActive(bool: true)
            chatBalloonView.commonLabelConstraintIsActive(bool: true)
            balloonConstraint = chatBalloonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            chatBalloonView.fillLayerColor(color: UIColor.blue)
        
        } else {
            addSubview(loadingView)
            chatBalloonView.leftLabelConstraintIsActive(bool: true)
            balloonConstraint = chatBalloonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            if chatBalloonView.text != "" {
                self.loadingView.isHidden = true
                chatBalloonView.emptyLabelConstraintIsActive(bool: false)
                chatBalloonView.commonLabelConstraintIsActive(bool: true)
                
            } else {
                self.loadingView.isHidden = false
                chatBalloonView.emptyLabelConstraintIsActive(bool: true)
                chatBalloonView.emptyLabelConstraintIsActive(bool: true)
            }
        }
        balloonConstraint.isActive = true

    }
    
    override func prepareForReuse() {
        print("재사용")
        chatBalloonView.direction = .right
        chatBalloonView.emptyLabelConstraintIsActive(bool: false)
        chatBalloonView.leftLabelConstraintIsActive(bool: false)
        chatBalloonView.rightLabelConstraintIsActive(bool: false)
        chatBalloonView.commonLabelConstraintIsActive(bool: false)
        self.loadingView.isHidden = true
    }
}
