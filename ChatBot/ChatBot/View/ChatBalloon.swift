//
//  ChatBalloon.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//
import UIKit

final class ChatBalloon: UIView {
    
    var direction: Direction = .right
    
    private var rightLabelConstraint = [NSLayoutConstraint]()
    private var leftLabelConstraint = [NSLayoutConstraint]()
    private var commonLabelConstraint = [NSLayoutConstraint]()
    private var emptyLabelWidthConstraint = NSLayoutConstraint()
    private var emptyLabelHeightConstraint = NSLayoutConstraint()
    
    private let balloonLayer = CAShapeLayer()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = .max
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var text: String? {
        didSet {
            label.text = text
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.addSublayer(balloonLayer)
        addSubview(label)
        
        rightLabelConstraint = [label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)]
        
        leftLabelConstraint = [label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0)]
        
        commonLabelConstraint = [label.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
                                 label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0)]
        
        emptyLabelWidthConstraint = label.widthAnchor.constraint(equalToConstant: 50)
        emptyLabelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 100)
//        NSLayoutConstraint.activate(commonLabelConstraint)
    }
    
    func leftOrRight(direction: Direction) {
 
        if direction == .right {
//            NSLayoutConstraint.deactivate(leftLabelConstraint)
//            NSLayoutConstraint.activate(rightLabelConstraint)
            leftLabelConstraintIsActive(bool: false)
            rightLabelConstraintIsActive(bool: true)
        } else {
            //            NSLayoutConstraint.deactivate(rightLabelConstraint)
            //            NSLayoutConstraint.activate(leftLabelConstraint)
            leftLabelConstraintIsActive(bool: true)
            rightLabelConstraintIsActive(bool: false)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch direction {
        case .right:
            drawBalloonToRight()
            self.balloonLayer.fillColor = UIColor.blue.cgColor
        case .left:
            drawBalloonToLeft()
            self.balloonLayer.fillColor = UIColor.brown.cgColor
        }
    }
    
    func emptyLabelConstraintIsActive(bool: Bool) {
        emptyLabelWidthConstraint.isActive = bool
        emptyLabelHeightConstraint.isActive = bool
    }
    
    func commonLabelConstraintIsActive(bool: Bool)
    {
        if bool {
            NSLayoutConstraint.activate(commonLabelConstraint)
        } else {
            NSLayoutConstraint.deactivate(commonLabelConstraint)
        }
    }
    func leftLabelConstraintIsActive(bool: Bool) {
        
        if bool {
            NSLayoutConstraint.activate(leftLabelConstraint)
//            NSLayoutConstraint.activate(commonLabelConstraint)
        } else {
            NSLayoutConstraint.deactivate(leftLabelConstraint)
//            NSLayoutConstraint.deactivate(commonLabelConstraint)
        }
    }
    
    func rightLabelConstraintIsActive(bool: Bool) {
        
        if bool {
            NSLayoutConstraint.activate(rightLabelConstraint)
//            NSLayoutConstraint.activate(commonLabelConstraint)
        } else {
            NSLayoutConstraint.deactivate(rightLabelConstraint)
//            NSLayoutConstraint.deactivate(commonLabelConstraint)
        }
    }
    
    func fillLayerColor(color: UIColor) {
        balloonLayer.fillColor = color.cgColor
    }
    
    private func drawBalloonToRight() {
        let width = bounds.size.width
        let height = bounds.size.height
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: width - 22, y: height))
        bezierPath.addLine(to: CGPoint(x: 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
        bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
        bezierPath.close()
        
        balloonLayer.path = bezierPath.cgPath
        label.textAlignment = .left
    }
    
    private func drawBalloonToLeft() {
        let width = bounds.size.width
        let height = bounds.size.height
        
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 22, y: height))
        bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
        bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
        bezierPath.addLine(to: CGPoint(x: width, y: 17))
        bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
        bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
        bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
        bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
        bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
        bezierPath.close()

        balloonLayer.path = bezierPath.cgPath
        label.textAlignment = .left
    }
}
