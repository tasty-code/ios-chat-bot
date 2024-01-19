//
//  LoadingIndicator.swift
//  ChatBot
//
//  Created by Janine on 1/17/24.
//

import UIKit

final class LoadingIndicator: UIView {

    // MARK: - Properties

    private(set) var isAnimating = false

    var bounceOffset: CGFloat = 2.5
    var isBounceEnabled = false
    var isFadeEnabled = true

    // MARK: - Subviews

    let stackView = UIStackView()

    let dots: [BubbleCircle] = {
        [BubbleCircle(), BubbleCircle(), BubbleCircle()]
    }()

    var dotColor = UIColor.lightGray {
        didSet {
          dots.forEach { $0.backgroundColor = dotColor }
        }
      }

      var initialOffsetAnimationLayer: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.byValue = -bounceOffset
        animation.duration = 0.5
        animation.isRemovedOnCompletion = true

        return animation
      }

      var bounceAnimationLayer: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.toValue = -bounceOffset
        animation.fromValue = bounceOffset
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true

        return animation
      }

      /// The `CABasicAnimation` applied when `isFadeEnabled` is TRUE
      var opacityAnimationLayer: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.5
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true

        return animation
      }

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        stackView.spacing = bounds.width > 0 ? 5 : 0
    }

    // MARK: - Animation

    func startAnimating() {
        defer { isAnimating = true }
        guard !isAnimating else { return }
        var delay: TimeInterval = 0
        for dot in dots {
          DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.isBounceEnabled {
              dot.layer.add(self.initialOffsetAnimationLayer, forKey: AnimationKeys.offset)
              let bounceLayer = self.bounceAnimationLayer
              bounceLayer.timeOffset = delay + 0.33
              dot.layer.add(bounceLayer, forKey: AnimationKeys.bounce)
            }
            if self.isFadeEnabled {
              dot.layer.add(self.opacityAnimationLayer, forKey: AnimationKeys.opacity)
            }
          }
          delay += 0.33
        }
      }

      func stopAnimating() {
        defer { isAnimating = false }
        guard isAnimating else { return }
        dots.forEach {
          $0.layer.removeAnimation(forKey: AnimationKeys.bounce)
          $0.layer.removeAnimation(forKey: AnimationKeys.opacity)
        }
      }

    // MARK: - Private

    private func setupView() {
        dots.forEach {
            $0.backgroundColor = dotColor
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
    }

    private enum AnimationKeys {
        static let offset = "typingIndicator.offset"
        static let bounce = "typingIndicator.bounce"
        static let opacity = "typingIndicator.opacity"
    }
}
