//
//  LoadingView.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/19.
//

import UIKit

final class LoadingView: UIView {
    private let firstCircle = CALayer()
    private let secondCircle = CALayer()
    private let thirdCircle = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        moveCircle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("LoadingView Error")
    }
    
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        makeCircle(circleLayer: firstCircle, position: CGPoint(x: bounds.width / 4 * 1 , y: bounds.height / 2))
        makeCircle(circleLayer: secondCircle, position: CGPoint(x: bounds.width / 4 * 2 , y: bounds.height / 2))
        makeCircle(circleLayer: thirdCircle, position: CGPoint(x: bounds.width / 4 * 3 , y: bounds.height / 2))
    }
    
    func makeCircle(circleLayer: CALayer, position: CGPoint) {
        circleLayer.bounds = CGRect(x: 0, y: 0, width: frame.height * 0.2, height: frame.height * 0.2)
        circleLayer.position = position
        circleLayer.cornerRadius = circleLayer.bounds.width / 2
        circleLayer.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(circleLayer)
    }

    func moveCircle() {
        let animation = CAKeyframeAnimation(keyPath: "position.y")
        animation.duration = 1
        animation.repeatCount = Float.infinity
        
        animation.values = [firstCircle.position.y, bounds.height * -0.05, firstCircle.position.y]
        animation.keyTimes = [0.1, 0.4, 0.7]
        firstCircle.add(animation, forKey: nil)
        
        animation.values = [secondCircle.position.y, bounds.height * -0.05, secondCircle.position.y]
        animation.keyTimes = [0.2, 0.5, 0.8]
        secondCircle.add(animation, forKey: nil)
        
        animation.values = [thirdCircle.position.y, bounds.height * -0.05, thirdCircle.position.y]
        animation.keyTimes = [0.3, 0.6, 0.9]
        thirdCircle.add(animation, forKey: nil)
    }
}

