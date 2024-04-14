//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class ChatBotViewController: UIViewController {

  private lazy var chatCollectionView: ChatCollectionView = {
    var configure = UICollectionLayoutListConfiguration(appearance: .plain)
    configure.showsSeparators = false
    let layout = UICollectionViewCompositionalLayout.list(using: configure)
    let collectionView = ChatCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.allowsSelection = false
    return collectionView
  }()
  private lazy var dataSource = ChatCollectionViewDataSource(collectionView: chatCollectionView)
  private let chatBotViewModel: ChatViewModel = .init()
  private var cancellable = Set<AnyCancellable>()
  private let input: PassthroughSubject<ChatViewModel.Input, Never> = .init()
  private let chatInputView = ChatInputView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupKeyboardNotification()
    setupCollectionView()
    configureUI()
    setupConstraints()
    bind()
    setupChatInputView()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

private extension ChatBotViewController {
  func configureUI() {
    view.backgroundColor = .white
    view.addSubview(chatCollectionView)
    view.addSubview(chatInputView)
  }
  
  func setupCollectionView() {
    self.chatCollectionView.dataSource = dataSource
  }
  
  func setupConstraints() {
    chatInputView.translatesAutoresizingMaskIntoConstraints = false
    chatCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate(
      [
        chatCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        chatCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        chatCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        chatCollectionView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor, constant: -10),
        chatInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        chatInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        chatInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
  }
  
  func setupChatInputView() {
    chatInputView.setChatSendButton { [weak self] message in
      self?.input.send(.sendButtonTapped(message: message))
      guard let requestDTO = self?.chatBotViewModel.requestDTO else { return }
      self?.applyChatResponse(response: requestDTO)
    }
  }
  
  func bind() {
    let output = chatBotViewModel.transform(
      input: input.eraseToAnyPublisher()
    )
    output.sink { [weak self] event in
      switch event {
      case .fetchChatResponseDidFail(let error):
        print(error.localizedDescription)
      case .fetchChatResponseDidSucceed(let response):
        self?.applyChatResponse(response: response)
      case .toggleSendButton(let isEnable):
        self?.chatInputView.isEnable = isEnable
      }
    }
    .store(in: &cancellable)
  }
  
  func applyChatResponse(response: [RequestDTO]) {
    var chatCollectionViewSnapshot = ChatCollectionViewSnapshot()
    chatCollectionViewSnapshot.appendSections([.messages])
    chatCollectionViewSnapshot.appendItems(response)
    dataSource.apply(chatCollectionViewSnapshot)
    chatCollectionView.srollToBottom()
  }
}
