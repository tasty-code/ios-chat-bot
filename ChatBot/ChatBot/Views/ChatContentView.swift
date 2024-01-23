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
    
    private lazy var bubble: BubbleView = {
        let bubble = BubbleView()
        bubble.backgroundColor = .systemBackground
        addSubview(bubble)
        bubble.addSubview(textLabel)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    private var userConstraints: [NSLayoutConstraint]!
    private var assistantConstraints: [NSLayoutConstraint]!
    private var loadingConstraints: [NSLayoutConstraint]!
    
    init(configuration: ChatContentConfiguration) {
        super.init(frame: .zero)
        setConstraints()

        userConstraints = [
            bubble.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -20),
        ]
        
        assistantConstraints = [
            bubble.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: -3),
            textLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -20),
        ]
        
        loadingConstraints = [
            bubble.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: -3),
            dotsView.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 34),
            dotsView.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 20),
            dotsView.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -20),
        ]
        
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bubble.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            bubble.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            
            textLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 5),
            textLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -5),
        ])
    }
    
    private func apply(_ configuration: ChatContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        textLabel.text = configuration.content
        
        guard let sender = configuration.sender else { return }
        bubble.sender = sender
        
        switch sender {
        case .assistant:
            NSLayoutConstraint.activate(self.assistantConstraints)
            NSLayoutConstraint.deactivate(self.userConstraints)
            NSLayoutConstraint.deactivate(self.loadingConstraints)
            textLabel.textColor = .black
            dotsView.stopAnimating()
            dotsView.isHidden = true
            break
        case .user:
            NSLayoutConstraint.activate(self.userConstraints)
            NSLayoutConstraint.deactivate(self.assistantConstraints)
            NSLayoutConstraint.deactivate(self.loadingConstraints)
            textLabel.textColor = .white
            break
        case .loading:
            bubble.addSubview(dotsView)
            NSLayoutConstraint.activate(self.loadingConstraints)
            NSLayoutConstraint.deactivate(self.userConstraints)
            NSLayoutConstraint.deactivate(self.assistantConstraints)
            dotsView.beginAnimating()
            dotsView.isHidden = false
            break
        }
    }
}
