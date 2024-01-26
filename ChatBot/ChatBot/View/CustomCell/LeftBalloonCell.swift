//
//  LeftBalloonCell.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class LeftBalloonCell: UICollectionViewListCell {
    
    private lazy var chatBalloonView: ChatBalloon = ChatBalloon()
    private lazy var loadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
    
    private var balloonDirectionConstraint = NSLayoutConstraint()
    private var loadingViewConstraint = [NSLayoutConstraint]()
    private var chatBallonViewConstraint = [NSLayoutConstraint]()
    private var contentViewHeightConstraint = NSLayoutConstraint()
    
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
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 60)
        contentViewHeightConstraint.priority = .defaultHigh
        loadingViewConstraint = [
            contentViewHeightConstraint,
            loadingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ]
        
        chatBallonViewConstraint = [
            chatBalloonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            chatBalloonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            chatBalloonView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            chatBalloonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(chatBallonViewConstraint)
    }
    
    func setLabelText(text: String) {
        chatBalloonView.text = text
    }
 
    func makeBalloon() {
        chatBalloonView.setDirection(direction: .left)
        chatBalloonView.leftBalloon()
        
        if chatBalloonView.text != "" {
            loadingView.isHidden = true
            NSLayoutConstraint.deactivate(loadingViewConstraint)
            chatBalloonView.emptyLabelConstraintIsActive(bool: false)
        } else {
            loadingView.isHidden = false
            NSLayoutConstraint.activate(loadingViewConstraint)
            chatBalloonView.emptyLabelConstraintIsActive(bool: true)
            loadingView.moveCircle()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chatBalloonView.text = ""
        chatBalloonView.emptyLabelConstraintIsActive(bool: false)
        chatBalloonView.commonLabelConstraintIsActive(bool: false)
    }
}
