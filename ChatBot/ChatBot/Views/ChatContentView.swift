//
//  ChatContentView.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/16/24.
//

import UIKit

final class ChatContentView: UIView, UIContentView {
    private var appliedConfiguration: ChatContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? ChatContentConfiguration else { return }
            apply(newConfig)
        }
    }
    
    private lazy var dotsView : DotsView = {
        let dots = DotsView()
        dots.translatesAutoresizingMaskIntoConstraints = false
        return dots
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bubbleView: BubbleView = {
        let bubble = BubbleView()
        bubble.backgroundColor = .systemBackground
        addSubview(bubble)
        bubble.addSubview(textLabel)
        bubble.addSubview(dotsView)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    private lazy var userConstraints: [NSLayoutConstraint] = [
        bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        textLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
        textLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -20),
    ]
    
    private lazy var assistantConstraints: [NSLayoutConstraint] = [
        bubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        textLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 20),
        textLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -20),
    ]
    
    private lazy var loadingConstraints: [NSLayoutConstraint] = [
        bubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        bubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
        dotsView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 34),
        dotsView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 20),
        dotsView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -20),
    ]
    
    init(configuration: ChatContentConfiguration) {
        super.init(frame: .zero)
        setConstraints()
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setConstraints() {
        userConstraints.forEach { constraint in
            constraint.priority = .defaultLow
        }
        assistantConstraints.forEach { constraint in
            constraint.priority = .defaultLow
        }
        loadingConstraints.forEach { constraint in
            constraint.priority = .defaultLow
        }
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            textLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            textLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
        ])
    }
    
    private func apply(_ configuration: ChatContentConfiguration) {
        guard let sender = configuration.sender else { return }
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        textLabel.text = configuration.content
        bubbleView.sender = sender
        
        switch sender {
        case .assistant:
            configureAssistantView()
        case .user:
            configureUserView()
        case .loading:
            configureLoadingView()
        }
    }
    
    private func configureAssistantView() {
        NSLayoutConstraint.activate(self.assistantConstraints)
        NSLayoutConstraint.deactivate(self.userConstraints)
        NSLayoutConstraint.deactivate(self.loadingConstraints)
        textLabel.textColor = .black
        dotsView.stopAnimating()
        dotsView.isHidden = true
    }
    
    private func configureUserView() {
        NSLayoutConstraint.activate(self.userConstraints)
        NSLayoutConstraint.deactivate(self.assistantConstraints)
        NSLayoutConstraint.deactivate(self.loadingConstraints)
        textLabel.textColor = .white
        dotsView.isHidden = true
    }
    
    private func configureLoadingView() {
        NSLayoutConstraint.activate(self.loadingConstraints)
        NSLayoutConstraint.deactivate(self.userConstraints)
        NSLayoutConstraint.deactivate(self.assistantConstraints)
        dotsView.startAnimating()
        dotsView.isHidden = false
    }
}
