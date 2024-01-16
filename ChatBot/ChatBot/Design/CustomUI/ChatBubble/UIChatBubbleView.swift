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
    
    var text: String? {
        didSet {
            contentLabel.text = text
            setNeedsDisplay()
        }
    }
    
    var startDirection: StartDirection {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width = contentLabel.text == nil ? emptyWidth : bounds.size.width
        let height = contentLabel.text == nil ? emptyHeight : bounds.size.height
        
        let bezierPath = UIBezierPath()
        switch startDirection {
        case .left:
            drawLeftChatBubble(to: bezierPath, width: width, height: height)
            bubbleLayer.fillColor = UIColor.lightGray.cgColor
        case .right:
            drawRightChatBubble(to: bezierPath, width: width, height: height)
            bubbleLayer.fillColor = UIColor.systemBlue.cgColor
        }
        
        if text == nil {
            drawWaitingDots(to: bezierPath)
        }
        
        bubbleLayer.path = bezierPath.cgPath
    }
    
    private func drawLeftChatBubble(to bezierPath: UIBezierPath, width: Double, height: Double) {
        bezierPath.move(to: CGPoint(x: 22, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: width, y: 17))
        bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
        bezierPath.close()
    }
    
    private func drawRightChatBubble(to bezierPath: UIBezierPath, width: Double, height: Double) {
        bezierPath.move(to: CGPoint(x: width - 22, y: height))
        bezierPath.addLine(to: CGPoint(x: 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
        bezierPath.close()
    }
    
    private func drawWaitingDots(to bezierPath: UIBezierPath) {
        let centerPoint = CGPoint(x: emptyWidth / 2, y: emptyHeight / 2)
        let startPoint = CGPoint(x: emptyWidth / 2 - dotsSpacing, y: emptyHeight / 2)
        let endPoint = CGPoint(x: emptyWidth / 2 + dotsSpacing, y: emptyHeight / 2)
        
        bezierPath.move(to: CGPoint(x: centerPoint.x + 5, y: centerPoint.y))
        bezierPath.addArc(withCenter: centerPoint, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        bezierPath.move(to: CGPoint(x: startPoint.x + 5, y: startPoint.y))
        bezierPath.addArc(withCenter: startPoint, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        bezierPath.move(to: CGPoint(x: endPoint.x + 5, y: endPoint.y))
        bezierPath.addArc(withCenter: endPoint, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
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
