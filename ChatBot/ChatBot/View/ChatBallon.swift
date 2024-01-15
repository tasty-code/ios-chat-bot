//
//  ChatBallon.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//

import UIKit

final class ChatBallon: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("ChatBallon Init Error")
    }
    
    private func configure() {
        self.addSubview(label)
        self.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
        ])
    }
}

//MARK: - 말풍선 그리기

extension ChatBallon {
    
    override func draw(_ rect: CGRect) {
        let color = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        makeBubble(color: color)
    }
    
    private func makeBubble(color: UIColor) {
        
        let radius: CGFloat = 8
        let width = layer.frame.width - 16 - radius
        let height = layer.frame.height - radius * 3
        
        let startPointX: CGFloat = radius * 2
        let startPointY:CGFloat = radius * 2
        let tailendPoint = CGPoint(x: layer.frame.width - 16,
                                   y: startPointY * 0.6)
        
        color.setFill()
        
        let bodyPath = UIBezierPath()
        let tailPath = UIBezierPath()
        
        bodyPath.move(to: CGPoint(x: startPointX + radius, y: startPointY))
        bodyPath.addLine(to: CGPoint(
            x: tailendPoint.x - 16,
            y: startPointY))
        bodyPath.addArc(withCenter: CGPoint(
            x: tailendPoint.x - 16,
            y: startPointY + radius),
                        radius: radius,
                        startAngle: CGFloat.pi * 3 / 2,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        
        bodyPath.addLine(to: CGPoint(
            x: tailendPoint.x - 16 + radius,
            y: height))
        bodyPath.addArc(withCenter: CGPoint(
            x: tailendPoint.x - 16,
            y: height + radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: CGFloat.pi / 2,
                        clockwise: true)
        
        bodyPath.addLine(to: CGPoint(
            x: startPointX + radius,
            y: height + radius * 2))
        bodyPath.addArc(withCenter: CGPoint(
            x: startPointX + radius,
            y: height + radius),
                        radius: radius,
                        startAngle: CGFloat.pi / 2,
                        endAngle: CGFloat.pi,
                        clockwise: true)
        
        bodyPath.addLine(to: CGPoint(
            x: startPointX,
            y: startPointY + radius))
        bodyPath.addArc(withCenter: CGPoint(
            x: startPointX + radius,
            y: startPointY + radius),
                        radius: radius,
                        startAngle: CGFloat.pi,
                        endAngle: CGFloat.pi * 3 / 2,
                        clockwise: true)
        
        bodyPath.fill()
        
        tailPath.move(to: CGPoint(x: tailendPoint.x, y: tailendPoint.y))
        tailPath.addCurve(to: CGPoint(x: tailendPoint.x - 16,
                                      y: startPointY),
                          controlPoint1: CGPoint(x: (tailendPoint.x - width) * 0.6 + width,
                                                 y: (startPointY - tailendPoint.y) * 0.6 + tailendPoint.y),
                          controlPoint2: CGPoint(x: (tailendPoint.x - width) * 0.2  + width,
                                                 y: (startPointY - tailendPoint.y) * 0.95 + tailendPoint.y))
        
        tailPath.addLine(to: CGPoint(x: tailendPoint.x - 16,
                                     y: startPointY + radius * 3))
        tailPath.addCurve(to: CGPoint(x: tailendPoint.x,
                                      y: tailendPoint.y),
                          controlPoint1: CGPoint(x: (tailendPoint.x - width) * 0.8 + width,
                                                 y: ((startPointY + radius) - tailendPoint.y) * 0.9 + tailendPoint.y),
                          controlPoint2: CGPoint(x: (tailendPoint.x - width) * 0.9 + width,
                                                 y: ((startPointY + radius) - tailendPoint.y) * 0.6 + tailendPoint.y))
        
        tailPath.fill()
    }
}
