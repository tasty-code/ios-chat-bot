//
//  ComdoriView.swift
//  ChatBot
//
//  Created by 김예준 on 1/15/24.
//
import UIKit

enum role {
    case assistant
    case user
}

final class BubbleView: UIView {
    var color = UIColor()
    
    override func draw(_ rect: CGRect) {
        
        
//        role.assistant ? GPTBubbleMake(color: color) : userBubbleMake(color: color)
        userBubbleMake(color: color)
//        GPTBubbleMake(color: color)
       
    }
    
    func userBubbleMake(color: UIColor) {
        let bubbleRect = CGRect(x: 0, y: 0, width: layer.frame.width - 10, height: layer.frame.height)
        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
        let plus = CGFloat(10)
        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX + plus, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY - plus))
        color.setFill()
        path.fill()
        path.close()
    }
    
    
    func GPTBubbleMake(color: UIColor) {
        let bubbleRect = CGRect(x: 10, y: 0, width: layer.frame.width - 10, height: layer.frame.height)
        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        let plus = CGFloat(10)
        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.minX - plus, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.minX + plus, y: bubbleRect.maxY - plus))
        color.setFill()
        path.fill()
        path.close()
    }
}
