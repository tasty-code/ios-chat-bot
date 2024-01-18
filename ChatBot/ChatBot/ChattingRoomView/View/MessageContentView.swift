import UIKit

final class MessageContentView: UIView, UIContentView {
    private let bubbleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dotLayer: CAReplicatorLayer
    
    private var appliedConfiguration: MessageViewContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfiguration = newValue as? MessageViewContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    init() {
        dotLayer = CAReplicatorLayer()
        super.init(frame: .zero)
        
        layer.addSublayer(dotLayer)
        
        addSubview(bubbleLabel)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 없음")
    }
}

// MARK: AutoLayout Methods
extension MessageContentView {
    private func setConstraint() {
        NSLayoutConstraint.activate([
            bubbleLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            bubbleLabel.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            bubbleLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            bubbleLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

// MARK: Configuration
extension MessageContentView {
    private func apply(configuration: MessageViewContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        bubbleLabel.text = configuration.text
    }
}

// MARK: Draw Methods
extension MessageContentView {
    override func draw(_ rect: CGRect) {
        if bubbleLabel.text!.isEmpty && appliedConfiguration.role != .user {
            drawAnimatingDots(dotXOffset: 6.0, dotSize: 4.0, dotSpacing: 8.0)
        }
    }
    
    private func drawAnimatingDots(dotXOffset: CGFloat, dotSize: CGFloat, dotSpacing: CGFloat) {
        let layer = CAReplicatorLayer()
        let backgroundLayer = CALayer()
        
        dotLayer.addSublayer(layer)
        backgroundLayer.frame = CGRect(x: bounds.width / 2 - dotXOffset,
                           y: bounds.height / 2,
                           width: dotSize,
                           height: dotSize)
        
        backgroundLayer.cornerRadius = backgroundLayer.frame.width / 2
        backgroundLayer.backgroundColor = UIColor.black.cgColor
        
        layer.addSublayer(backgroundLayer)
        layer.instanceCount = 3
        layer.instanceTransform = CATransform3DMakeTranslation(dotSpacing, 0, 0)
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.2
        animation.duration = 1
        animation.repeatCount = .infinity
        
        backgroundLayer.add(animation, forKey: nil)
        layer.instanceDelay = animation.duration / Double(layer.instanceCount)
    }
}
