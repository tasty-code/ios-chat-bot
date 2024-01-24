//
//  BubbleTailView.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/15.

import UIKit

final class BubbleTailView: UIView {
    
    override func draw(_ rect: CGRect) {
        let minX: CGFloat = bounds.minX
        let minY: CGFloat = bounds.minY
        let maxX: CGFloat = bounds.maxX
        let maxY: CGFloat = bounds.maxY

        let tailPath = UIBezierPath()
        tailPath.move(to: CGPoint(x: minX, y: maxY))
        tailPath.addLine(to: CGPoint(x: maxX, y: minY))
        tailPath.addLine(to: CGPoint(x: minX, y: minY))
        tailPath.close()

        UIColor.white.set()
        tailPath.fill()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
