//
//  UIChatBubbleView.swift
//  ChatBot
//
//  Created by 김준성 on 1/12/24.
//

import UIKit

final class UIChatBubbleView: UIView {
    private let emptyWidth: CGFloat
    private let emptyHeight: CGFloat
    private let dotsSpacing: CGFloat
    private let bubbleLayer = CAShapeLayer()
    private let contentLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    private var startDirection: StartDirection
    
    override init(frame: CGRect) {
        self.emptyWidth = 0
        self.emptyHeight = 0
        self.dotsSpacing = 0
        self.startDirection = .right
        super.init(frame: frame)
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(emptyWidth: CGFloat, emptyHeight: CGFloat, dotsSpacing: CGFloat, frame: CGRect) {
        self.emptyWidth = emptyWidth
        self.emptyHeight = emptyHeight
        self.dotsSpacing = dotsSpacing
        self.startDirection = .right
        super.init(frame: frame)
        setConstraint()
    }
    
    func setText(_ text: String?, direction: StartDirection) {
        self.contentLabel.text = text
        self.startDirection = direction
    }
    
    private func setConstraint() {
        layer.addSublayer(bubbleLayer)
        addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = contentLabel.text == nil ? emptyWidth : bounds.size.width
        let height = contentLabel.text == nil ? emptyHeight : bounds.size.height
        
        let bezierPath = UIBezierPath()
        switch startDirection {
        case .left:
            bezierPath.drawLeftChatBubble(width: width, height: height)
            bubbleLayer.fillColor = UIColor.lightGray.cgColor
        case .right:
            bezierPath.drawRightChatBubble(width: width, height: height)
            bubbleLayer.fillColor = UIColor.systemBlue.cgColor
        }
        bezierPath.close()
        
        if contentLabel.text == nil {
            bezierPath.drawDots(
                size: 5,
                points:
                    CGPoint(x: emptyWidth / 2, y: emptyHeight / 2),
                    CGPoint(x: emptyWidth / 2 - dotsSpacing, y: emptyHeight / 2),
                    CGPoint(x: emptyWidth / 2 + dotsSpacing, y: emptyHeight / 2)
            )
            executeAnimation()
        }
        
        bubbleLayer.path = bezierPath.cgPath
    }
    
    private func executeAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.autoreverses = true
        self.layer.add(animation, forKey: "opacity")
    }
}

extension UIChatBubbleView {
    enum StartDirection {
        case left
        case right
    }
}
