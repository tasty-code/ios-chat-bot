//
//  DotsView.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/23/24.
//

import UIKit

class DotsView: UIView {
    
    public var baseline: CGFloat = 0
    public var dotXOffset: CGFloat = 4.0
    public var dotSize: CGFloat = 15
    public var dotSpacing: CGFloat = 25
    
    private let copyLayer = CAReplicatorLayer()
    private let dot = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        copyLayer.addSublayer(dot)
        layer.addSublayer(copyLayer)
    }
    public func beginAnimating() {
        dot.frame = CGRect(x: dotXOffset, y: baseline - dotSize, width: dotSize, height: dotSize)
        dot.cornerRadius = dot.frame.width / 2.0
        dot.backgroundColor = UIColor.systemCyan.cgColor
        copyLayer.instanceCount = 3
        copyLayer.instanceTransform = CATransform3DMakeTranslation(dotSpacing, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = .infinity
        dot.add(anim, forKey: nil)
        copyLayer.instanceDelay = anim.duration / Double(copyLayer.instanceCount)
    }
    public func stopAnimating() {
        layer.removeAllAnimations()
    }
    
}
