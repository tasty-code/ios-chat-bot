//
//  ChatBubbleView.swift
//  Swift_CoreGraphics
//
//  Created by 강창현 on 4/4/24.
//

import UIKit

final class UserBubbleView: UIView {
  var messageView: MessageLabel = .init()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentMode = .redraw
    self.backgroundColor = .clear
    configureUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func draw(_ rect: CGRect) {
    setRightBubbleView(rect: rect)
  }
}

extension UserBubbleView: ChatBubbleMakable { }

final class SystemBubbleView: UIView {
  var messageView: MessageLabel = .init()
  
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
  
  override func draw(_ rect: CGRect) {
    setLeftBubbleView(rect: rect)
  }
}

extension SystemBubbleView: ChatBubbleMakable { }
