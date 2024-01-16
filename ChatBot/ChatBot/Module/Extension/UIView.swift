//
//  UIView.swift
//  ChatBot
//
//  Created by 동준 on 1/16/24.
//

import UIKit

extension UIView {
    func addTipViewToLeftBottom(with color: UIColor?) {
        layoutIfNeeded()
        let height = frame.height
     
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -18, y: height))
        path.addLine(to: CGPoint(x: 18, y: height))
        path.addLine(to: CGPoint(x: 0, y: height - 15))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = color?.cgColor
        layer.insertSublayer(shape, at: 0)
    }
    
    func addTipViewToRightBottom(with color: UIColor?) {
        layoutIfNeeded()
        
        let height = frame.height
        let width = frame.width
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: width + 18, y: height))
        path.addLine(to: CGPoint(x: width, y: height - 18))
        path.addLine(to: CGPoint(x: width - 18, y: height - 18))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = color?.cgColor
        layer.insertSublayer(shape, at: 0)
    }
}
