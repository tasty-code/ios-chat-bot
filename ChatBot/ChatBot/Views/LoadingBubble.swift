//
//  LoadingBubble.swift
//  ChatBot
//
//  Created by Janine on 1/17/24.
//

import UIKit

final class LoadingBubble: UIView {
    
    // MARK: - Properties
    
    private(set) var isAnimating = false
    
    var isPulseEnabled: Bool = true
    
    override var backgroundColor: UIColor? {
        set {
            [contentBubble, cornerBubble, tinyBubble].forEach { $0.backgroundColor = newValue }
        } get {
            contentBubble.backgroundColor
        }
    }
    
    // MARK: - Subviews
    
    let loadingIndicator = LoadingIndicator()
    let contentBubble = UIView()
    let cornerBubble = BubbleCircle()
    let tinyBubble = BubbleCircle()
    
    //MARK: - Animation Layers
    
    var contentPulseAnimationLayer: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.fromValue = 1
        animation.toValue = 1.04
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.autoreverses = true
        
        return animation
    }
    
    var circlePulseAnimationLayer: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.fromValue = 1
        animation.toValue = 1.1
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        
        return animation
    }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Animation
    func startAnimating() {
        defer { isAnimating = true }
        
        guard !isAnimating else { return }
        loadingIndicator.startAnimating()
        
        if isPulseEnabled {
            contentBubble.layer.add(
                contentPulseAnimationLayer,
                forKey: AnimationKeys.pulse
            )
            
            [cornerBubble, tinyBubble].forEach { $0.layer.add(
                circlePulseAnimationLayer,
                forKey: AnimationKeys.pulse
            )}
        }
    }
    
    func stopAnimating() {
        defer { isAnimating = false }
        
        guard isAnimating else { return }
        loadingIndicator.stopAnimating()
        
        [contentBubble, cornerBubble, tinyBubble].forEach { $0.layer.removeAnimation(forKey: AnimationKeys.pulse)
        }
    }
    
    // MARK: - Private
    
    private enum AnimationKeys {
        static let pulse = "typingBubble.pulse"
    }
}
