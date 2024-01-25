//
//  DotsView.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/23/24.
//

import UIKit

final class DotsView: UIView {
    private lazy var baseline: CGFloat = 0
    private lazy var dotXOffset: CGFloat = 4.0
    private lazy var dotSize: CGFloat = 15
    private lazy var dotSpacing: CGFloat = 25
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
    
    private func commonInit() {
        copyLayer.addSublayer(dot)
        layer.addSublayer(copyLayer)
    }
    
    func startAnimating() {
        dot.frame = CGRect(x: dotXOffset, y: baseline - dotSize, width: dotSize, height: dotSize)
        dot.cornerRadius = dot.frame.width / 2.0
        dot.backgroundColor = UIColor.systemCyan.cgColor
        copyLayer.instanceCount = 3
        copyLayer.instanceTransform = CATransform3DMakeTranslation(dotSpacing, 0, 0)
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = 1.0
        animation.toValue = 0.2
        animation.duration = 1
        animation.repeatCount = .infinity
        dot.add(animation, forKey: nil)
        copyLayer.instanceDelay = animation.duration / Double(copyLayer.instanceCount)
    }
    
    func stopAnimating() {
        layer.removeAllAnimations()
    }
}
