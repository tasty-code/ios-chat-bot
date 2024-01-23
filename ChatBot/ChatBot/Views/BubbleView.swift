//
//  ComdoriView.swift
//  ChatBot
//
//  Created by 김예준 on 1/15/24.
//
import UIKit

final class BubbleView: UIView {
    var sender: Sender? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        switch sender {
        case .assistant:
            makeAssistantBubble()
        case .user:
            makeUserBubble()
        case .loading:
            makeLoadingBubble()
        case .none:
            return
        }		
    }
    
    private func makeUserBubble() {
        let bubbleRect = CGRect(x: 0, y: 0, width: layer.frame.width - 10, height: layer.frame.height)
        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
        let plus = CGFloat(10)
        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX + plus, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY - plus))
        UIColor.systemBlue.setFill()
        path.fill()
        path.close()
    }
    
    private func makeAssistantBubble() {
        let bubbleRect = CGRect(x: 10, y: 0, width: layer.frame.width - 10, height: layer.frame.height)
        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        let plus = CGFloat(10)
        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.minX - plus, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.minX + plus, y: bubbleRect.maxY - plus))
        UIColor.systemGray3.setFill()
        path.fill()
        path.close()
    }
    
    private func makeLoadingBubble() {
        let bubbleRect = CGRect(x: 10, y: 0, width: 90, height: 50)
        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        let plus = CGFloat(10)
        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.minX - plus, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.minX + plus, y: bubbleRect.maxY - plus))
        UIColor.systemGray3.setFill()
        path.fill()
        path.close()
    }
}
