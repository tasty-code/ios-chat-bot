//
//  ChatBalloon.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/12.
//
import UIKit

final class ChatBalloon: UIView {
    
    private var direction: Direction = .right
    
    private var rightLabelConstraint = [NSLayoutConstraint]()
    private var leftLabelConstraint = [NSLayoutConstraint]()
    private var commonLabelConstraint = [NSLayoutConstraint]()
    private var emptyLabelWidthConstraint = NSLayoutConstraint()
    
    private let balloonLayer = CAShapeLayer()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDirection(direction: Direction) {
        self.direction = direction
    }
    
    private func configure() {
        layer.addSublayer(balloonLayer)
        addSubview(label)
        
        rightLabelConstraint = [label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
                                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)]
        
        leftLabelConstraint = [label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
                               label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0)]
        
        commonLabelConstraint = [label.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
                                 label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0)]
        
        emptyLabelWidthConstraint = label.widthAnchor.constraint(equalToConstant: 50)
    }
}


// MARK: - Constraint

extension ChatBalloon {
    func leftBalloon() {
        let leftColor = #colorLiteral(red: 0.5870948434, green: 0.7980247736, blue: 0.985825479, alpha: 1)
        NSLayoutConstraint.activate(leftLabelConstraint)
        NSLayoutConstraint.activate(commonLabelConstraint)
        fillLayerColor(color: leftColor)
    }
    
    func rightBalloon() {
        let rightColor = #colorLiteral(red: 1, green: 0.7630318403, blue: 0.8500509858, alpha: 1)
        NSLayoutConstraint.activate(rightLabelConstraint)
        NSLayoutConstraint.activate(commonLabelConstraint)
        
        fillLayerColor(color: rightColor)
    }
    
    func emptyLabelConstraintIsActive(bool: Bool) {
        emptyLabelWidthConstraint.isActive = bool
    }
    
    func commonLabelConstraintIsActive(bool: Bool) {
        if bool {
            NSLayoutConstraint.activate(commonLabelConstraint)
        } else {
            NSLayoutConstraint.deactivate(commonLabelConstraint)
        }
    }
}


// MARK: - Drawing Animation

extension ChatBalloon {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch direction {
        case .right:
            drawBalloonToRight()
        case .left:
            drawBalloonToLeft()
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
