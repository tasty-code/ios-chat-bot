//
//  LoadingAnimationView.swift
//  ChatBot
//
//  Created by 전성수 on 1/17/24.
//

import UIKit

final class LoadingAnimationView: UIView {
    
    enum Constant {
        static let circleSize: CGFloat = 16
    }
    
    // MARK: - properties
    
    private let animationContainer: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let firstCircle: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constant.circleSize / 2
        return view
    }()
    
    private let secondCircle: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constant.circleSize / 2
        return view
    }()
    
    private let lastCircle: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constant.circleSize / 2
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLoadingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

extension LoadingAnimationView {
    
    private func configureLoadingView() {
        addSubview(animationContainer)
        
        let subViews = [firstCircle, secondCircle, lastCircle]
        subViews.forEach { subView in
            animationContainer.addArrangedSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            animationContainer.topAnchor.constraint(equalTo: topAnchor),
            animationContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            animationContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            firstCircle.widthAnchor.constraint(equalToConstant: Constant.circleSize),
            firstCircle.heightAnchor.constraint(equalToConstant: Constant.circleSize),
            secondCircle.widthAnchor.constraint(equalToConstant: Constant.circleSize),
            secondCircle.heightAnchor.constraint(equalToConstant: Constant.circleSize),
            lastCircle.widthAnchor.constraint(equalToConstant: Constant.circleSize),
            lastCircle.heightAnchor.constraint(equalToConstant: Constant.circleSize),
        ])
    }
}

// MARK: - internal methods

extension LoadingAnimationView {
    
    func runSpinner() {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.repeat]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                self.firstCircle.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.6) {
                self.firstCircle.alpha = 1
                self.secondCircle.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.9) {
                self.secondCircle.alpha = 1
                self.lastCircle.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 1) {
                self.lastCircle.alpha = 1
            }
        }
    }
}
