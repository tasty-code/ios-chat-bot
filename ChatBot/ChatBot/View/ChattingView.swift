//
//  ChattingView.swift
//  ChatBot
//
//  Created by 강창현 on 4/21/24.
//

import UIKit

final class ChattingView: UIView {
  private lazy var chatCollectionView: ChatCollectionView = {
    var configure = UICollectionLayoutListConfiguration(appearance: .plain)
    configure.showsSeparators = false
    let layout = UICollectionViewCompositionalLayout.list(using: configure)
    let collectionView = ChatCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.allowsSelection = false
    return collectionView
  }()
  
  private lazy var dataSource = ChatCollectionViewDataSource(collectionView: chatCollectionView)
  
  private let chatInputView = ChatInputView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupCollectionView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setChatSendButton(completion: @escaping (_ message: Message) -> Void) {
    chatInputView.setChatSendButton(completion: completion)
  }
  
  func isSendButtonEnable(_ isEnable: Bool) {
    chatInputView.isEnable = isEnable
  }
  
  func applyChatResponse(response: [RequestDTO]) {
    var chatCollectionViewSnapshot = ChatCollectionViewSnapshot()
    chatCollectionViewSnapshot.appendSections([.messages])
    chatCollectionViewSnapshot.appendItems(response)
    dataSource.apply(chatCollectionViewSnapshot)
    chatCollectionView.scrollToBottom()
  }
}

private extension ChattingView {
  func configureUI() {
    self.backgroundColor = .white
    self.addSubview(chatCollectionView)
    self.addSubview(chatInputView)
  }
  
  func setupCollectionView() {
    self.chatCollectionView.dataSource = dataSource
  }
  
  func setupConstraints() {
    chatInputView.translatesAutoresizingMaskIntoConstraints = false
    chatCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate(
      [
        chatCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        chatCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        chatCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        chatCollectionView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor, constant: -10),
        chatInputView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        chatInputView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        chatInputView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
  }
}
