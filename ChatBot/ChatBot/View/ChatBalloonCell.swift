//
//  ChatBalloonCell.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class ChatBalloonCell: UICollectionViewListCell {
    private var balloonConstraint = NSLayoutConstraint()
    
    private lazy var chatBalloonView: ChatBalloon = {
        let view = ChatBalloon()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let loadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44)))
    private var loadingViewConstraint = [NSLayoutConstraint]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatBalloonCell Init Error")
    }
    
    private func configure() {
        self.contentView.addSubview(chatBalloonView)
        
        NSLayoutConstraint.activate([
            chatBalloonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            chatBalloonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            chatBalloonView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
        ])
        
        loadingViewConstraint = [
            loadingView.topAnchor.constraint(equalTo: self.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.widthAnchor.constraint(equalToConstant: loadingView.frame.width),
        ]
    }
    
    func setLabelText(text: String) {
        chatBalloonView.text = text
    }
    var hiddenConstraint = [NSLayoutConstraint]()
    var visibilityConstraint = [NSLayoutConstraint]()
    
    func setDirection(direction: Direction) {
        chatBalloonView.direction = direction
        
        hiddenConstraint = []
        
        if direction == .right {
            balloonConstraint = chatBalloonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            chatBalloonView.leftOrRight(direction: .right)
        } else {
            addSubview(loadingView)
            if chatBalloonView.text == "" {
                self.loadingView.isHidden = false
                chatBalloonView.ssss()
                NSLayoutConstraint.activate(loadingViewConstraint)
            } else {
                self.loadingView.isHidden = true
            }
            
            balloonConstraint = chatBalloonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            chatBalloonView.leftOrRight(direction: .left)
        }
        balloonConstraint.isActive = true
    }
    
    override func prepareForReuse() {
        NSLayoutConstraint.deactivate(loadingViewConstraint)
        balloonConstraint.isActive = false
        self.loadingView.isHidden = true
    }
}
