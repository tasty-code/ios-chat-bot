//
//  LoadingView.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/19/24.
//

import UIKit

class LoadingView: UIView {
    
    let circleLayer1 = CALayer()
    let circleLayer2 = CALayer()
    let circleLayer3 = CALayer()
    lazy var circleLayers: [CALayer] = [circleLayer1, circleLayer2, circleLayer3]
    
    lazy var initialPosition = CGPoint(x: 50, y: self.bounds.maxY / 3)
    lazy var finalPosition = CGPoint(x: 50, y: self.bounds.maxY / 3 * 2)
    
    override func draw(_ rect: CGRect) {
        let size = self.bounds.width / 7
        
        for i in 0..<circleLayers.count {
            circleLayers[i].frame = .init(x: self.bounds.maxX / 3 * CGFloat(i), y: self.bounds.minY, width: size, height: size)
            circleLayers[i].cornerRadius = circleLayers[i].bounds.width / 2
            circleLayers[i].backgroundColor = UIColor.black.cgColor
            layer.addSublayer(circleLayers[i])
            setAnimation(customLayer: circleLayers[i], delay: 0.1 * Double(i))
        }
    }
    
    func setAnimation(customLayer: CALayer, delay: TimeInterval) {
        let moveAnimation = CAKeyframeAnimation(keyPath: "position.y")
        moveAnimation.values = [initialPosition.y, finalPosition.y, initialPosition.y]
        moveAnimation.keyTimes = [0, 0.5, 1]
        moveAnimation.duration = 1.0
        moveAnimation.repeatCount = .infinity
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        moveAnimation.beginTime = CACurrentMediaTime() + delay
        customLayer.add(moveAnimation, forKey: nil)
        
        let colorAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
        colorAnimation.values = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.5869942307, green: 0.9386706948, blue: 1, alpha: 1).cgColor]
        colorAnimation.repeatCount = .infinity
        colorAnimation.duration = 1
        customLayer.add(colorAnimation, forKey: nil)
    }
    
}
