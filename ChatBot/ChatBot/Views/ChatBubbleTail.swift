//
//  ChatBubbleCustom.swift
//  ChatBot
//
//  Created by 동준 on 1/19/24.
//

import UIKit

final class ChatBubbleTail: UIView {

    var color: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY
        
        context.move(to: CGPoint(x: minX, y: minY))
        context.addLine(to: CGPoint(x: minX, y: maxY))
        context.addLine(to: CGPoint(x: maxX, y: maxY))
        context.addLine(to: CGPoint(x: minX, y: minY))
        context.closePath()
        
        context.setFillColor(color.cgColor)
        
        context.fillPath()
    }
}
