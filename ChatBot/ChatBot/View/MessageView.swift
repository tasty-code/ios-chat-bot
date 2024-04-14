//
//  MessageView.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/4.
//

import UIKit

final class MessageView: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension MessageView {
  func configureUI() {
    self.backgroundColor = .clear
    self.textAlignment = .left
    self.numberOfLines = 0
  }
}
