//
//  ChatInputTextView.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/8.
//

import UIKit

final class ChatInputTextView: UITextView {
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    self.font = .preferredFont(forTextStyle: .body)
    self.layer.borderWidth = 1
    self.layer.cornerRadius = 17
    self.layer.borderColor = UIColor.systemGray2.cgColor
    self.isScrollEnabled = false
    self.textContainerInset.left = 10
    self.textContainerInset.right = 10
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
