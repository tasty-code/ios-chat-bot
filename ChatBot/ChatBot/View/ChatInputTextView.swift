//
//  ChatInputTextView.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/8.
//

import UIKit

final class ChatInputTextView: UITextView, UITextViewDelegate {
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    self.font = .systemFont(ofSize: 20)
    self.layer.borderWidth = 2
    self.layer.cornerRadius = 20
    self.layer.borderColor = CGColor(red: 0.1, green: 0.1, blue: 0.5, alpha: 1)
    self.isScrollEnabled = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let size = CGSize(width: self.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    textView.constraints.forEach { constraints in
      if constraints.firstAttribute == .height {
        constraints.constant = estimatedSize.height
      }
    }
  }
}
