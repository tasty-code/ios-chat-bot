//
//  BezierPath+extension.swift
//  ChatBot
//
//  Created by 김준성 on 1/17/24.
//

import UIKit

extension UIBezierPath {
    func drawRightChatBubble(width: Double, height: Double) {
        // 우측 하단부로 이동
        move(to: CGPoint(x: width - 22, y: height))
        
        // 우측 하단부 -> 좌측 하단부
        addLine(to: CGPoint(x: 17, y: height))
        addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        
        // 좌측 하단부 -> 좌측 상단부
        addLine(to: CGPoint(x: 0, y: 17))
        addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        
        // 좌측 상단부 -> 우측 상단부
        addLine(to: CGPoint(x: width - 21, y: 0))
        addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        
        // 우측 상단부 -> 우측 하단부
        addLine(to: CGPoint(x: width - 4, y: height - 11))
        addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        
        // 말꼬리
        addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
    }
    
    func drawLeftChatBubble(width: Double, height: Double) {
        
        // 좌측 하단부로 이동
        move(to: CGPoint(x: 22, y: height))
        
        // 좌측 하단부 -> 우측 하단부
        addLine(to: CGPoint(x: width - 17, y: height))
        addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
        
        // 우측 하단부 -> 우측 상단부
        addLine(to: CGPoint(x: width, y: 17))
        addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
        
        // 우측 상단부 -> 좌측 상단부
        addLine(to: CGPoint(x: 21, y: 0))
        addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
        
        // 좌측 상단부 -> 우측 하단부
        addLine(to: CGPoint(x: 4, y: height - 11))
        addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
        
        // 말꼬리
        addLine(to: CGPoint(x: -0.05, y: height - 0.01))
        addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
        addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
    }
    
    func drawDots(size: CGFloat, points: CGPoint...) {
        for point in points {
            move(to: CGPoint(x: point.x + size, y: point.y))
            addArc(withCenter: point, radius: size, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }
    }
}
