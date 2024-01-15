//
//  ComdoriView.swift
//  ChatBot
//
//  Created by 김예준 on 1/15/24.
//
import UIKit

class BubbleView: UILabel {
    
    private var width: Int!
    private var height: Int!
    
    required init(width: Int, height: Int) {
        super.init(frame: .zero)
        
        self.width = width
        self.height = height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        // user
        let bubbleRect = CGRect(x: 5, y: 5, width: width, height: height)
        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
        let plus = CGFloat(10)
        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX + plus, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY - plus))
        path.close()
        
        // gpt
        //        let bubbleRect = CGRect(x: 10, y: 5, width: 100, height: 50)
        //        let path = UIBezierPath(roundedRect: bubbleRect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        //        let plus = CGFloat(10)
        //        path.move(to: CGPoint(x: bubbleRect.maxX, y: bubbleRect.maxY))
        //        path.addLine(to: CGPoint(x: bubbleRect.minX - plus, y: bubbleRect.maxY))
        //        path.addLine(to: CGPoint(x: bubbleRect.minX + plus, y: bubbleRect.maxY - plus))
        //        path.close()
        
        // CAShapeLayer 객체 생성
        let layer = CAShapeLayer()
        layer.path = path.cgPath    // CGPath(Core Graphics) 타입으로 전달
        
        // 그리기 속성 설정
        layer.lineWidth = 3
        layer.fillColor = UIColor.systemGray4.cgColor
        //        layer.addSublayer(msgLabel)
        // View의 서브 Layer에 shapeLayer를 추가
        self.layer.addSublayer(layer)
    }
}
