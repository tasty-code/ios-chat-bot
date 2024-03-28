//
//  ChatLoadingIndicator.swift
//  ChatBot
//
//  Created by Kim EenSung on 3/28/24.
//

import UIKit

class ChatLoadingIndicator: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let bubbleWidth: CGFloat = 100
        let bubbleHeight: CGFloat = bubbleWidth * 0.35
        return CGSize(width: bubbleWidth + 20, height: bubbleHeight + 20)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let padding: CGFloat = 10
        let startX: CGFloat = rect.minX + padding
        let startY: CGFloat = rect.minY + padding
        
        let bubbleWidth: CGFloat = 100
        let bubbleHeight: CGFloat = bubbleWidth * 0.35
        
        context?.addPath(CGPath(roundedRect: CGRect(x: startX, y: startY, width: bubbleWidth, height: bubbleHeight), cornerWidth: 10, cornerHeight: 10, transform: nil))
        context?.setFillColor(UIColor.systemGray5.cgColor)
        context?.fillPath()
        
        let tailStartPoint: CGPoint = CGPoint(x: startX, y: startY + bubbleHeight * 0.4)
        let tailTipPoint: CGPoint = CGPoint(x: startX - 10, y: startY + bubbleHeight * 0.7)
        let tailEndPoint: CGPoint = CGPoint(x: startX, y: startY + bubbleHeight * 0.65)
        let tailControlPoint: CGPoint = CGPoint(x: startX - 3, y: startY + bubbleHeight * 0.67)
        
        context?.move(to: tailStartPoint)
        context?.addQuadCurve(to: tailTipPoint, control: tailControlPoint)
        context?.addQuadCurve(to: tailEndPoint, control: tailControlPoint)
        context?.setFillColor(UIColor.systemGray5.cgColor)
        context?.fillPath()
        
        context?.addEllipse(in: CGRect(x: bubbleWidth * 0.2, y: bubbleHeight * 0.5, width: bubbleWidth * 0.2, height: bubbleWidth * 0.2))
        context?.addEllipse(in: CGRect(x: bubbleWidth * 0.5, y: bubbleHeight * 0.5, width: bubbleWidth * 0.2, height: bubbleWidth * 0.2))
        context?.addEllipse(in: CGRect(x: bubbleWidth * 0.8, y: bubbleHeight * 0.5, width: bubbleWidth * 0.2, height: bubbleWidth * 0.2))
        context?.setFillColor(UIColor.systemGray3.cgColor)
        context?.fillPath()
    }
}
