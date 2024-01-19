import UIKit

final class MessageContentView: UIView, UIContentView {
    private let bubbleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var dotLayer: CAReplicatorLayer = {
        let dotLayer = drawAnimatingDots(dotXOffset: 6.0, dotSize: 4.0, dotSpacing: 8.0)
        layer.addSublayer(dotLayer)
        return dotLayer
    }()
    
    private var appliedConfiguration: MessageViewContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfiguration = newValue as? MessageViewContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    init() {
        super.init(frame: .zero)
        
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
        
        dotLayer.isHidden = configuration.role == .user || (configuration.text?.isEmpty == false)
    }
}

// MARK: Draw Methods
extension MessageContentView {
    private func drawAnimatingDots(dotXOffset: CGFloat, dotSize: CGFloat, dotSpacing: CGFloat) -> CAReplicatorLayer {
        let layer = CAReplicatorLayer()
        let backgroundLayer = CALayer()
        
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
        return layer
    }
}
