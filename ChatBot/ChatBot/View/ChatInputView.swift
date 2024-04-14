//
//  ChatInputView.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/8.
//

import UIKit

final class ChatInputView: UIView {
  private let chatInputTextView = ChatInputTextView()
  private let chatSendButton = ChatInputSendButton()
  var isEnable: Bool {
    get {
      chatSendButton.isEnabled
    }
    set {
      DispatchQueue.main.async {
        self.chatSendButton.isEnabled = newValue
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    self.chatInputTextView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setChatSendButton(completion: @escaping (_ message: Message) -> Void) {
    let action = UIAction { [weak self] _ in
      guard let text = self?.chatInputTextView.text else { return }
      completion(Message(role: "user", content: text))
      self?.chatInputTextView.text = ""
    }
    self.chatSendButton.addAction(action, for: .touchUpInside)
  }
}

private extension ChatInputView {
  func configureUI() {
    self.addSubview(chatInputTextView)
    self.addSubview(chatSendButton)
    setupConstraints()
  }
  
  func setupConstraints() {
    chatInputTextView.translatesAutoresizingMaskIntoConstraints = false
    chatSendButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      chatInputTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 15),
      chatInputTextView.trailingAnchor.constraint(equalTo: chatSendButton.leadingAnchor, constant: -5),
      chatInputTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      chatInputTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      chatSendButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 20),
      chatSendButton.heightAnchor.constraint(equalTo: chatSendButton.widthAnchor),
      chatSendButton.centerYAnchor.constraint(equalTo: chatInputTextView.centerYAnchor),
      chatSendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
    ])
  }
}

extension ChatInputView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    guard 
      textView.text.isEmpty
    else {
      self.chatSendButton.isEnabled = true
      return
    }
    self.chatSendButton.isEnabled = false
  }
}
