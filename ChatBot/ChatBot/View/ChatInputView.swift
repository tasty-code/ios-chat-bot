//
//  ChatInputView.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/8.
//

import UIKit

final class ChatInputView: UIView, UITextViewDelegate {
  private let chatInputTextView = ChatInputTextView()
  private let chatSendButton = ChatInputSendButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func textViewDidChange(_ textView: ChatInputTextView) {
    let size = CGSize(width: self.frame.width, height: .infinity)
    let estimatedSize = textView.sizeThatFits(size)
    textView.constraints.forEach { constraints in
      if constraints.firstAttribute == .height {
        constraints.constant = estimatedSize.height
      }
    }
  }
  
  private func configureUI() {
    self.addSubview(chatInputTextView)
    self.addSubview(chatSendButton)
    setupConstraints()
  }
  
  private func setupConstraints() {
    chatInputTextView.translatesAutoresizingMaskIntoConstraints = false
    chatSendButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      chatInputTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
      chatInputTextView.trailingAnchor.constraint(equalTo: chatSendButton.leadingAnchor, constant: -5),
      chatInputTextView.topAnchor.constraint(equalTo: self.topAnchor),
      chatInputTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      chatSendButton.widthAnchor.constraint(equalToConstant: 40),
      chatSendButton.heightAnchor.constraint(equalToConstant: 40),
      chatSendButton.centerYAnchor.constraint(equalTo: chatInputTextView.centerYAnchor),
      chatSendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
    ])
  }
}
