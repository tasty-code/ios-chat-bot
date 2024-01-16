//
//  ChatBubbleTail.swift
//  ChatBot
//
//  Created by 전성수 on 1/15/24.
//

import UIKit

@IBDesignable final class ChatBubbleTail: UIView {
    
    var color: UIColor = .systemYellow {
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
        
        context.setLineWidth(2)
        context.setStrokeColor(color.cgColor)
        context.move(to: CGPoint(x: minX, y: minY))
        context.addLine(to: CGPoint(x: minX, y: maxY))
        context.addLine(to: CGPoint(x: maxX, y: maxY))
        context.addLine(to: CGPoint(x: minX, y: minY))
        context.closePath()
        
        context.setFillColor(color.cgColor)
        
        context.fillPath()
        
        
    }
}
