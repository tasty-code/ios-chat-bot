//
//  BubbleCircle.swift
//  ChatBot
//
//  Created by Janine on 1/17/24.
//

import UIKit

final class BubbleCircle: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.mask = roundedMask(corners: .allCorners, radius: bounds.height / 2)
    }
    
    func roundedMask(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        return mask
    }
}
