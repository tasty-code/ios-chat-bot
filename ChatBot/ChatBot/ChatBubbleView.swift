//
//  ChatBubbleView.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/28/24.
//

import UIKit

class TestView: UIView {
    let chatBubbleView: ChatBubbleView = ChatBubbleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(chatBubbleView)
        
        chatBubbleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatBubbleView.centerYAnchor.constraint(equalTo: super.centerYAnchor),
            chatBubbleView.leadingAnchor.constraint(equalTo: super.leadingAnchor),
            chatBubbleView.trailingAnchor.constraint(equalTo: super.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatBubbleView: UIView {
    private var isUser: Bool = true
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureTextLabel()
        textLabel.text = """
안녕하세요.
"""
/*
테스트를 진행하는 중입니다.
만약 텍스트가 엄청나게 긴 문장을 담아야 하는 경우 이 텍스트는 어떻게 표현이 될까요?
텍스트 레이블이 실제 영역을 넘어가고 있는 것 같은데 이런 경우는 무엇 때문에 발생하고 어떻게 처리할 수 있을까요?
그 외에도 줄이 많아지면
이 것은 어떻게 처리가 될지도
궁금해집니다.
알아서 늘어나나요??
*/
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let padding: CGFloat = 10
        let startX: CGFloat = isUser ? rect.minX + padding : rect.midX - 50
        let startY: CGFloat = rect.minY + padding
        let endX: CGFloat = rect.maxX - padding
        let endY: CGFloat = rect.maxY - padding
        
        let bubbleWidth: CGFloat = endX - startX
        let bubbleHeight: CGFloat = endY - startY
        
        context?.addPath(CGPath(roundedRect: CGRect(x: startX, y: startY, width: bubbleWidth, height: bubbleHeight), cornerWidth: 10, cornerHeight: 10, transform: nil))
        context?.setFillColor(UIColor.systemGray5.cgColor)
        context?.fillPath()
        
        let tailStartPoint: CGPoint = CGPoint(x: isUser ? startX : endX, y: endY - 25)
        let tailTipPoint: CGPoint = CGPoint(x: isUser ? startX - 10 : endX + 10, y: endY - 15)
        let tailEndPoint: CGPoint = CGPoint(x: isUser ? startX : endX, y: endY - 15)
        let tailControlPoint: CGPoint = CGPoint(x: isUser ? startX - 3 : endX + 3, y: endY - 13)
        
        context?.move(to: tailStartPoint)
        context?.addQuadCurve(to: tailTipPoint, control: tailControlPoint)
        context?.addQuadCurve(to: tailEndPoint, control: tailControlPoint)
        context?.setFillColor(UIColor.systemGray5.cgColor)
        context?.fillPath()
    }
    
    func setUser(_ isUser: Bool) {
        self.isUser = isUser
    }
    
    private func configureTextLabel() {
        backgroundColor = .clear
        
        addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}

#Preview("TestView") {
    let view = TestView()
    return view
}
