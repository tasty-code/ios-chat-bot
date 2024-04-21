//
//  ChatBubbleMakable.swift
//  ChatBot
//
//  Created by 강창현 on 4/21/24.
//

import UIKit

protocol ChatBubbleMakable where Self: UIView {
  var messageLabel: MessageLabel { get }
  func configureUI()
  func setupConstraints()
  func setRightBubbleView(rect: CGRect)
  func setLeftBubbleView(rect: CGRect)
  func configureMessage(text: String)
}

extension ChatBubbleMakable {
  func configureUI() {
    self.addSubview(messageLabel)
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        self.heightAnchor.constraint(equalTo: messageLabel.heightAnchor, constant: 15),
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      ]
    )
  }
  
  func configureMessage(text: String) {
    messageLabel.text = text
  }
  
  func setRightBubbleView(rect: CGRect) {
    let path = UIBezierPath()
    messageLabel.textColor = .white
    let bottom = rect.height
    let right = rect.width
    path.move(
      to: CGPoint(x: right - 22, y: bottom)
    )
    path.addLine(
      to: CGPoint(x: 17, y: bottom)
    )
    path.addCurve(
      to: CGPoint(x: 0, y: bottom - 18),
      controlPoint1: CGPoint(x: 7.61, y: bottom),
      controlPoint2: CGPoint(x: 0, y: bottom - 7.61)
    )
    path.addLine(
      to: CGPoint(x: 0, y: 17)
    )
    path.addCurve(
      to: CGPoint(x: 17, y: 0),
      controlPoint1: CGPoint(x: 0, y: 7.61),
      controlPoint2: CGPoint(x: 7.61, y: 0)
    )
    path.addLine(
      to: CGPoint(x: right - 21, y: 0)
    )
    path.addCurve(
      to: CGPoint(x: right - 4, y: 17),
      controlPoint1: CGPoint(x: right - 11.61, y: 0),
      controlPoint2: CGPoint(x: right - 4, y: 7.61)
    )
    path.addLine(
      to: CGPoint(x: right - 4, y: bottom - 11)
    )
    path.addCurve(
      to: CGPoint(x: right, y: bottom),
      controlPoint1: CGPoint(x: right - 4, y: bottom - 1),
      controlPoint2: CGPoint(x: right, y: bottom)
    )
    path.addLine(
      to: CGPoint(x: right + 0.05, y: bottom - 0.01)
    )
    path.addCurve(
      to: CGPoint(x: right - 11.04, y: bottom - 4.04),
      controlPoint1: CGPoint(x: right - 4.07, y: bottom + 0.43),
      controlPoint2: CGPoint(x: right - 8.16, y: bottom - 1.06)
    )
    path.addCurve(
      to: CGPoint(x: right - 22, y: bottom),
      controlPoint1: CGPoint(x: right - 16, y: bottom),
      controlPoint2: CGPoint(x: right - 19, y: bottom)
    )
    path.close()
    UIColor(cgColor: UIColor.systemBlue.cgColor).setFill()
    path.fill()
  }
  
  func setLeftBubbleView(rect: CGRect) {
    let path = UIBezierPath()
    let bottom = rect.height
    let right = rect.width
    path.move(
      to: CGPoint(x: 22, y: bottom)
    )
    path.addLine(
      to: CGPoint(x: right - 17, y: bottom)
    )
    path.addCurve(
      to: CGPoint(x: right, y: bottom - 18),
      controlPoint1: CGPoint(x: right - 7.61, y: bottom),
      controlPoint2: CGPoint(x: right, y: bottom - 7.61)
    )
    path.addLine(
      to: CGPoint(x: right, y: 17)
    )
    path.addCurve(
      to: CGPoint(x: right - 17, y: 0),
      controlPoint1: CGPoint(x: right, y: 7.61),
      controlPoint2: CGPoint(x: right - 7.61, y: 0)
    )
    path.addLine(
      to: CGPoint(x: 21, y: 0)
    )
    path.addCurve(
      to: CGPoint(x: 4, y: 17),
      controlPoint1: CGPoint(x: 11.61, y: 0),
      controlPoint2: CGPoint(x: 4, y: 7.61)
    )
    path.addLine(
      to: CGPoint(x: 4, y: bottom - 11)
    )
    path.addCurve(
      to: CGPoint(x: 0, y: bottom),
      controlPoint1: CGPoint(x: 4, y: bottom - 1),
      controlPoint2: CGPoint(x: 0, y: bottom)
    )
    path.addLine(
      to: CGPoint(x: -0.05, y: bottom - 0.01)
    )
    path.addCurve(
      to: CGPoint(x: 11.04, y: bottom - 4.04),
      controlPoint1: CGPoint(x: 4.07, y: bottom + 0.43),
      controlPoint2: CGPoint(x: 8.16, y: bottom - 1.06)
    )
    path.addCurve(
      to: CGPoint(x: 22, y: bottom),
      controlPoint1: CGPoint(x: 16, y: bottom),
      controlPoint2: CGPoint(x: 19, y: bottom)
    )
    path.close()
    UIColor(cgColor: UIColor.systemGray5.cgColor).setFill()
    path.fill()
  }
}
