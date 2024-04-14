//
//  ChatSendButton.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/8.
//

import UIKit

final class ChatInputSendButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.isEnabled = false
    self.setBackgroundImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
