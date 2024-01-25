//
//  MessageContentView.swift
//  ChatBot
//
//  Created by 김진웅 on 1/12/24.
//

import UIKit

final class MessageContentView: UIView, UIContentView {
    
    // MARK: - UIContentConfiguration

    var configuration: UIContentConfiguration {
        didSet {
            guard let configuration = configuration as? MessageContentConfiguration else { return }
            apply(configuration)
        }
    }
    
    // MARK: - UI Components

    private lazy var chatBubble: ChatBubbleView = {
        let bubble = ChatBubbleView()
        bubble.backgroundColor = .clear
        
        addSubview(bubble)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    // MARK: - Constraint Property

    private lazy var defaultContentSize = chatBubble.contentSize
    private var positionConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Dot Property

    private let dotsCount = 3
    private let animationDuration: CFTimeInterval = 0.6
    private var dotLayers: [CALayer] = []
    
    // MARK: - Initializer

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setConstraints()
        readyForAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auto Layout

    private func setConstraints() {
        NSLayoutConstraint.activate([
            chatBubble.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            chatBubble.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            chatBubble.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.66)
        ])
    }
    
    // MARK: - ContentConfiguration Method

    private func apply(_ configuration: MessageContentConfiguration) {
        guard let message = configuration.message
        else {
            return
        }
        
        chatBubble.text = message.content
        
        let contentIsEmpty: Bool = message.content == nil
        toggleAnimation(isOn: contentIsEmpty)
        
        choosePosition(with: message.role)
    }
    
    // MARK: - Animation Method

    private func toggleAnimation(isOn: Bool) {
        widthConstraint?.isActive = isOn
        heightConstraint?.isActive = isOn
        isOn ? startAnimation() : stopAnimation()
    }

    private func readyForAnimation() {
        let dotSpacing: CGFloat = 10
        let totalWidth = (defaultContentSize + dotSpacing) * 3
        
        widthConstraint = chatBubble.widthAnchor.constraint(equalToConstant: totalWidth + 24)
        heightConstraint = chatBubble.heightAnchor.constraint(equalToConstant: defaultContentSize + 24)
        
        widthConstraint?.priority = .defaultLow
        heightConstraint?.priority = .defaultLow
        
        for i in 0..<dotsCount {
            let dotLayer = CALayer()
            dotLayer.frame = CGRect(
                x: defaultContentSize + CGFloat(i) * (defaultContentSize + dotSpacing),
                y: 12,
                width: defaultContentSize,
                height: defaultContentSize
            )
            
            dotLayer.backgroundColor = UIColor.white.cgColor
            dotLayer.cornerRadius = defaultContentSize / 2
            
            dotLayers.append(dotLayer)
        }
    }
    
    private func startAnimation() {
        for (index, dotLayer) in dotLayers.enumerated() {
            chatBubble.layer.addSublayer(dotLayer)
            
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.values = [1.0, 1.2, 1.0]
            animation.keyTimes = [0, 0.5, 1]
            animation.duration = animationDuration
            animation.beginTime = CACurrentMediaTime() + (animationDuration / Double(dotsCount) * Double(index))
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            dotLayer.add(animation, forKey: "loading")
        }
    }
    
    private func stopAnimation() {
        for dotLayer in dotLayers {
            dotLayer.removeAnimation(forKey: "loading")
            dotLayer.removeFromSuperlayer()
        }
    }
    
    // MARK: - ChatBubbleView Postion

    private func choosePosition(with role: MessageRole) {
        positionConstraint?.isActive = false
        switch role {
        case .user:
            chatBubble.direction = .right
            positionConstraint = chatBubble.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        case .system:
            break
        case .assistant:
            chatBubble.direction = .left
            positionConstraint = chatBubble.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        }
        positionConstraint?.isActive = true
    }
}
