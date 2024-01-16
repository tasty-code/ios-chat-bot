//
//  ComdoriView.swift
//  ChatBot
//
//  Created by 김예준 on 1/15/24.
//
import UIKit

final class BubbleView: UIView {
    var color = UIColor()

    override func draw(_ rect: CGRect) {
        createBubble(color: color)
    }
    
    func createBubble(color: UIColor) {
        // user
        let bubbleRect = CGRect(x: 0, y: 0, width: layer.frame.width - 10, height: layer.frame.height)
        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
        let plus = CGFloat(10)
        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX + plus, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY - plus))

        color.setFill()
        path.fill()
        path.close()
        
        // gpt
        //        let bubbleRect = CGRect(x: 10, y: 5, width: 100, height: 50)
        //        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        //        let plus = CGFloat(10)
        //        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        //        path.addLine(to: CGPoint(x: bubbleRect.minX - plus, y: bubbleRect.maxY))
        //        path.addLine(to: CGPoint(x: bubbleRect.minX + plus, y: bubbleRect.maxY - plus))
        //        path.close()
        
    }
}
