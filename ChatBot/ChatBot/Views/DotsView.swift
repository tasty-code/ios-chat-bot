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
    
    private let lay = CAReplicatorLayer()
    private let bar = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        lay.addSublayer(bar)
        layer.addSublayer(lay)
    }
    public func beginAnimating() {
        bar.frame = CGRect(x: dotXOffset, y: baseline - dotSize, width: dotSize, height: dotSize)
        bar.cornerRadius = bar.frame.width / 2.0
        bar.backgroundColor = UIColor.systemCyan.cgColor
        lay.instanceCount = 3
        lay.instanceTransform = CATransform3DMakeTranslation(dotSpacing, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = .infinity
        bar.add(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
    }
    public func stopAnimating() {
        layer.removeAllAnimations()
    }
    
}
