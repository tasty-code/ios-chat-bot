import UIKit

final class ChatBubbleView: UIView {

    let bubbleLayer = CAShapeLayer()

    let chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    var outcoming = Role.user

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() -> Void {
        layer.addSublayer(bubbleLayer)
        addSubview(chatLabel)

        NSLayoutConstraint.activate([
            chatLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            chatLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0),
            chatLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0),
            chatLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0),
            ])

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let width = bounds.size.width
        let height = bounds.size.height
        
        let bezierPath = UIBezierPath()

        if outcoming == .user {
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
        } else {
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
        }

        bubbleLayer.fillColor = (outcoming == .user) ? UIColor(named: "SunshineYellow")?.cgColor : UIColor(white: 0.90, alpha: 1.0).cgColor

        bubbleLayer.path = bezierPath.cgPath

    }
}
