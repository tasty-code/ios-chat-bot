//
//  ChatBubbleView.swift
//  Swift_CoreGraphics
//
//  Created by 강창현 on 4/4/24.
//

import UIKit

final class UserBubbleView: ChatBubbleView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentMode = .redraw
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    setupConstraints()
    setRightBubbleView(rect: rect)
  }
}

final class SystemBubbleView: ChatBubbleView {
  var isLoading: Bool {
    get {
      false
    }
    set {
      if !newValue {
          removeLoadingView()
        }
    }
  }
  
  private var loadingView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentMode = .redraw
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    guard isLoading else {
      setLeftBubbleView(rect: rect)
      return
    }
    addLoadingAnimation(to: rect)
    setLoadingBubbleView()
  }
  
  func configureMessage(text: String, isLoading: Bool) {
    messageView.text = text
    self.isLoading = isLoading
  }
  
  func addLoadingAnimation(to rect: CGRect) {
    let circleSize = CGSize(width: 10, height: 10) // 원의 크기
    let numberOfCircles = 3 // 원의 개수
    let circleSpacing: CGFloat = 10 // 원 사이의 간격
    let width: CGFloat = 80
    let height: CGFloat = 40
    // 로딩 중 표시를 위해 원을 그리는 뷰 생성
    loadingView = UIView(frame: CGRect(x: (width - CGFloat(numberOfCircles) * (circleSize.width + circleSpacing)) / 2,
                                           y: height / 2 - circleSize.height / 2,
                                           width: CGFloat(numberOfCircles) * (circleSize.width + circleSpacing),
                                           height: circleSize.height))
    
    // 원을 그리고 애니메이션을 추가
    for i in 0..<numberOfCircles {
      let circle = CALayer()
      circle.frame = CGRect(x: CGFloat(i) * (circleSize.width + circleSpacing),
                            y: 0,
                            width: circleSize.width,
                            height: circleSize.height)
      circle.backgroundColor = UIColor.systemBlue.cgColor
      circle.cornerRadius = circleSize.width / 2
      
      // 원을 이동시키는 애니메이션 추가
      let animation = CABasicAnimation(keyPath: "position.y")
      animation.duration = 1.0 // 애니메이션 속도
      animation.fromValue = circle.position.y
      animation.toValue = loadingView.frame.size.height
      animation.repeatCount = .infinity
      animation.autoreverses = true
      animation.timeOffset = TimeInterval(i) * 0.3 // 각 원의 애니메이션 시간을 조정하여 겹치지 않도록 함
      circle.add(animation, forKey: "position")
      
      loadingView.layer.addSublayer(circle)
    }
    
    // 메세지 버블 뷰에 로딩 뷰 추가
    addSubview(loadingView)
  }
  
  func removeLoadingView() {
    loadingView.layer.isHidden = true
  }
}

class ChatBubbleView: UIView {
  let messageView = MessageView()
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentMode = .redraw
    self.backgroundColor = .clear
    self.configureUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureMessage(text: String) {
    messageView.text = text
  }
}

private extension ChatBubbleView {
  func configureUI() {
    self.addSubview(messageView)
    messageView.translatesAutoresizingMaskIntoConstraints = false
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        self.heightAnchor.constraint(equalTo: messageView.heightAnchor, constant: 15),
        messageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        messageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        messageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      ]
    )
  }
  
  func setRightBubbleView(rect: CGRect) {
    let bezierPath = UIBezierPath()
    messageView.textColor = .white
    let bottom = rect.height
    let right = rect.width
    bezierPath.move(
      to: CGPoint(x: right - 22, y: bottom)
    )
    bezierPath.addLine(
      to: CGPoint(x: 17, y: bottom)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 0, y: bottom - 18),
      controlPoint1: CGPoint(x: 7.61, y: bottom),
      controlPoint2: CGPoint(x: 0, y: bottom - 7.61)
    )
    bezierPath.addLine(
      to: CGPoint(x: 0, y: 17)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 17, y: 0),
      controlPoint1: CGPoint(x: 0, y: 7.61),
      controlPoint2: CGPoint(x: 7.61, y: 0)
    )
    bezierPath.addLine(
      to: CGPoint(x: right - 21, y: 0)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right - 4, y: 17),
      controlPoint1: CGPoint(x: right - 11.61, y: 0),
      controlPoint2: CGPoint(x: right - 4, y: 7.61)
    )
    bezierPath.addLine(
      to: CGPoint(x: right - 4, y: bottom - 11)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right, y: bottom),
      controlPoint1: CGPoint(x: right - 4, y: bottom - 1),
      controlPoint2: CGPoint(x: right, y: bottom)
    )
    bezierPath.addLine(
      to: CGPoint(x: right + 0.05, y: bottom - 0.01)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right - 11.04, y: bottom - 4.04),
      controlPoint1: CGPoint(x: right - 4.07, y: bottom + 0.43),
      controlPoint2: CGPoint(x: right - 8.16, y: bottom - 1.06)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right - 22, y: bottom),
      controlPoint1: CGPoint(x: right - 16, y: bottom),
      controlPoint2: CGPoint(x: right - 19, y: bottom)
    )
    bezierPath.close()
    UIColor(cgColor: UIColor.systemBlue.cgColor).setFill()
    bezierPath.fill()
  }
  
  func setLoadingBubbleView() {
    let bezierPath = UIBezierPath()
    let bottom: CGFloat = 300
    let right: CGFloat = 500
    bezierPath.move(
      to: CGPoint(x: 22, y: bottom)
    )
    bezierPath.addLine(
      to: CGPoint(x: right - 17, y: bottom)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right, y: bottom - 18),
      controlPoint1: CGPoint(x: right - 7.61, y: bottom),
      controlPoint2: CGPoint(x: right, y: bottom - 7.61)
    )
    bezierPath.addLine(
      to: CGPoint(x: right, y: 17)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right - 17, y: 0),
      controlPoint1: CGPoint(x: right, y: 7.61),
      controlPoint2: CGPoint(x: right - 7.61, y: 0)
    )
    bezierPath.addLine(
      to: CGPoint(x: 21, y: 0)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 4, y: 17),
      controlPoint1: CGPoint(x: 11.61, y: 0),
      controlPoint2: CGPoint(x: 4, y: 7.61)
    )
    bezierPath.addLine(
      to: CGPoint(x: 4, y: bottom - 11)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 0, y: bottom),
      controlPoint1: CGPoint(x: 4, y: bottom - 1),
      controlPoint2: CGPoint(x: 0, y: bottom)
    )
    bezierPath.addLine(
      to: CGPoint(x: -0.05, y: bottom - 0.01)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 11.04, y: bottom - 4.04),
      controlPoint1: CGPoint(x: 4.07, y: bottom + 0.43),
      controlPoint2: CGPoint(x: 8.16, y: bottom - 1.06)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 22, y: bottom),
      controlPoint1: CGPoint(x: 16, y: bottom),
      controlPoint2: CGPoint(x: 19, y: bottom)
    )
    bezierPath.close()
    UIColor(cgColor: UIColor.systemGray5.cgColor).setFill()
    bezierPath.fill()
  }
  
  func setLeftBubbleView(rect: CGRect) {
    let bezierPath = UIBezierPath()
    let bottom = rect.height
    let right = rect.width
    bezierPath.move(
      to: CGPoint(x: 22, y: bottom)
    )
    bezierPath.addLine(
      to: CGPoint(x: right - 17, y: bottom)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right, y: bottom - 18),
      controlPoint1: CGPoint(x: right - 7.61, y: bottom),
      controlPoint2: CGPoint(x: right, y: bottom - 7.61)
    )
    bezierPath.addLine(
      to: CGPoint(x: right, y: 17)
    )
    bezierPath.addCurve(
      to: CGPoint(x: right - 17, y: 0),
      controlPoint1: CGPoint(x: right, y: 7.61),
      controlPoint2: CGPoint(x: right - 7.61, y: 0)
    )
    bezierPath.addLine(
      to: CGPoint(x: 21, y: 0)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 4, y: 17),
      controlPoint1: CGPoint(x: 11.61, y: 0),
      controlPoint2: CGPoint(x: 4, y: 7.61)
    )
    bezierPath.addLine(
      to: CGPoint(x: 4, y: bottom - 11)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 0, y: bottom),
      controlPoint1: CGPoint(x: 4, y: bottom - 1),
      controlPoint2: CGPoint(x: 0, y: bottom)
    )
    bezierPath.addLine(
      to: CGPoint(x: -0.05, y: bottom - 0.01)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 11.04, y: bottom - 4.04),
      controlPoint1: CGPoint(x: 4.07, y: bottom + 0.43),
      controlPoint2: CGPoint(x: 8.16, y: bottom - 1.06)
    )
    bezierPath.addCurve(
      to: CGPoint(x: 22, y: bottom),
      controlPoint1: CGPoint(x: 16, y: bottom),
      controlPoint2: CGPoint(x: 19, y: bottom)
    )
    bezierPath.close()
    UIColor(cgColor: UIColor.systemGray5.cgColor).setFill()
    bezierPath.fill()
  }
}

