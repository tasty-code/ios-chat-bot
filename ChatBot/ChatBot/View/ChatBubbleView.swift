//
//  ChatBubbleView.swift
//  ChatBot
//
//  Created by Matthew on 4/11/24.
//

import UIKit
import Then
import SnapKit

class ChatBubbleView: UIView {
    private let messageView = MessageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        self.backgroundColor = .clear
        self.configureUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMessage(text: String) {
        messageView.text = text
    }
    
    func configureUI() {
        self.addSubview(messageView)
    }
    
    func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(messageView.snp.height)
        }
        
        messageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            if self is UserBubbleView {
                make.trailing.equalToSuperview().offset(-10)
                make.leading.greaterThanOrEqualToSuperview().offset(10)
            }
            else {
                make.leading.equalToSuperview().offset(10)
                make.trailing.lessThanOrEqualToSuperview().offset(-10)
            }
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 0.75)
        }
    }
    
    func setRightBubbleView(rect: CGRect) {
        let bezierPath = UIBezierPath()
        messageView.textColor = .white
        let bottom = rect.height
        let right = rect.width
        bezierPath.move(
            to: CGPoint(x: right - 22, y: bottom)
        )
        bezierPath.addLine(
            to: CGPoint(x: 17, y: bottom)
        )
        bezierPath.addCurve(
            to: CGPoint(x: 0, y: bottom - 18),
            controlPoint1: CGPoint(x: 7.61, y: bottom),
            controlPoint2: CGPoint(x: 0, y: bottom - 7.61)
        )
        bezierPath.addLine(
            to: CGPoint(x: 0, y: 17)
        )
        bezierPath.addCurve(
            to: CGPoint(x: 17, y: 0),
            controlPoint1: CGPoint(x: 0, y: 7.61),
            controlPoint2: CGPoint(x: 7.61, y: 0)
        )
        bezierPath.addLine(
            to: CGPoint(x: right - 21, y: 0)
        )
        bezierPath.addCurve(
            to: CGPoint(x: right - 4, y: 17),
            controlPoint1: CGPoint(x: right - 11.61, y: 0),
            controlPoint2: CGPoint(x: right - 4, y: 7.61)
        )
        bezierPath.addLine(
            to: CGPoint(x: right - 4, y: bottom - 11)
        )
        bezierPath.addCurve(
            to: CGPoint(x: right, y: bottom),
            controlPoint1: CGPoint(x: right - 4, y: bottom - 1),
            controlPoint2: CGPoint(x: right, y: bottom)
        )
        bezierPath.addLine(
            to: CGPoint(x: right + 0.05, y: bottom - 0.01)
        )
        bezierPath.addCurve(
            to: CGPoint(x: right - 11.04, y: bottom - 4.04),
            controlPoint1: CGPoint(x: right - 4.07, y: bottom + 0.43),
            controlPoint2: CGPoint(x: right - 8.16, y: bottom - 1.06)
        )
        bezierPath.addCurve(
            to: CGPoint(x: right - 22, y: bottom),
            controlPoint1: CGPoint(x: right - 16, y: bottom),
            controlPoint2: CGPoint(x: right - 19, y: bottom)
        )
        bezierPath.close()
        UIColor(cgColor: UIColor.systemBlue.cgColor).setFill()
        bezierPath.fill()
    }
    
    func setLeftBubbleView(rect: CGRect) {
        let bezierPath = UIBezierPath()
        let bottom = rect.height
        let right = rect.width
        
        bezierPath.move(
            to: CGPoint(x: 22, y: bottom)
        )
        bezierPath.addLine(
            to: CGPoint(x: right - 17, y: bottom)
        )
        bezierPath.addCurve(
            to: CGPoint(x: right, y: bottom - 18),
            controlPoint1: CGPoint(x: right - 7.61, y: bottom),
            controlPoint2: CGPoint(x: right, y: bottom - 7.61)
        )
        bezierPath.addLine(
            to: CGPoint(x: right, y: 17)
        )
        bezierPath.addCurve(
            to: CGPoint(x: right - 17, y: 0),
            controlPoint1: CGPoint(x: right, y: 7.61),
            controlPoint2: CGPoint(x: right - 7.61, y: 0)
        )
        bezierPath.addLine(
            to: CGPoint(x: 21, y: 0)
        )
        bezierPath.addCurve(
            to: CGPoint(x: 4, y: 17),
            controlPoint1: CGPoint(x: 11.61, y: 0),
            controlPoint2: CGPoint(x: 4, y: 7.61)
        )
        bezierPath.addLine(
            to: CGPoint(x: 4, y: bottom - 11)
        )
        bezierPath.addCurve(
            to: CGPoint(x: 0, y: bottom),
            controlPoint1: CGPoint(x: 4, y: bottom - 1),
            controlPoint2: CGPoint(x: 0, y: bottom)
        )
        bezierPath.addLine(
            to: CGPoint(x: -0.05, y: bottom - 0.01)
        )
        bezierPath.addCurve(
            to: CGPoint(x: 11.04, y: bottom - 4.04),
            controlPoint1: CGPoint(x: 4.07, y: bottom + 0.43),
            controlPoint2: CGPoint(x: 8.16, y: bottom - 1.06)
        )
        bezierPath.addCurve(
            to: CGPoint(x: 22, y: bottom),
            controlPoint1: CGPoint(x: 16, y: bottom),
            controlPoint2: CGPoint(x: 19, y: bottom)
        )
        bezierPath.close()
        UIColor(cgColor: UIColor.systemGray5.cgColor).setFill()
        bezierPath.fill()
    }
}
