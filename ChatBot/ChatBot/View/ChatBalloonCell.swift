//
//  ChatBalloonCell.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class ChatBalloonCell: UICollectionViewListCell {
    
    private lazy var chatBalloonView: ChatBalloon = ChatBalloon()
    
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
        print("dkdkdkdkdkdk")
        if direction == .right {
//            chatBalloonView.leftLabelConstraintIsActive(bool: false)
            chatBalloonView.rightLabelConstraintIsActive(bool: true)
            chatBalloonView.commonLabelConstraintIsActive(bool: true)
            balloonConstraint = chatBalloonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            chatBalloonView.fillLayerColor(color: UIColor.blue)
        
        } else {
            addSubview(loadingView)
            chatBalloonView.leftLabelConstraintIsActive(bool: true)
//            chatBalloonViㄹew.fillLayerColor(color: .brown)
            balloonConstraint = chatBalloonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            if chatBalloonView.text != "" {
                self.loadingView.isHidden = true
                chatBalloonView.commonLabelConstraintIsActive(bool: true)
            } else {
                self.loadingView.isHidden = false
                chatBalloonView.emptyLabelConstraintIsActive(bool: true)
            }
        }
        balloonConstraint.isActive = true
        
        
//        if direction == .right {
//            balloonConstraint = chatBalloonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
//            chatBalloonView.leftOrRight(direction: .right)
//            chatBalloonView.rightLabelConstraintIsActive(bool: true)
//            loadingView.isHidden = true
//            let color = #colorLiteral(red: 0.5743555427, green: 0.6444449425, blue: 1, alpha: 1)
//            chatBalloonView.fillLayerColor(color: color)
//            
//        } else {
//            let color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//            chatBalloonView.fillLayerColor(color: color)
//            chatBalloonView.rightLabelConstraintIsActive(bool: false)
//            if chatBalloonView.text == "" {
//                
//                self.loadingView.isHidden = false
//                chatBalloonView.emptyLabelConstraintIsActive(bool: true)
//                chatBalloonView.leftLabelConstraintIsActive(bool: false)
//                NSLayoutConstraint.activate(loadingViewConstraint)
//                
//            } else {
//                
//                chatBalloonView.emptyLabelConstraintIsActive(bool: false)
//                chatBalloonView.leftLabelConstraintIsActive(bool: true)
//                self.loadingView.isHidden = true
//                
//            }
//            
//            balloonConstraint = chatBalloonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
//            chatBalloonView.leftOrRight(direction: .left)
//        }
//        balloonConstraint.isActive = true
    }
    
    override func prepareForReuse() {
        print("재사용")
//        chatBalloonView.fillLayerColor(color: .blue)
//        chatBalloonView.emptyLabelConstraintIsActive(bool: false)
//        chatBalloonView.leftLabelConstraintIsActive(bool: false)
//        chatBalloonView.rightLabelConstraintIsActive(bool: false)
//        balloonConstraint.isActive = false
//        NSLayoutConstraint.deactivate(loadingViewConstraint)
//        self.loadingView.removeFromSuperview()
        
        chatBalloonView.direction = .right
        chatBalloonView.emptyLabelConstraintIsActive(bool: false)
        chatBalloonView.leftLabelConstraintIsActive(bool: false)
        chatBalloonView.rightLabelConstraintIsActive(bool: false)
        chatBalloonView.commonLabelConstraintIsActive(bool: false)
        self.loadingView.isHidden = true
        balloonConstraint.isActive = false
        
    }
}
