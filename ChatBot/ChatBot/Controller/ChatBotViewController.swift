//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class ChatBotViewController: UIViewController {
  static let notificationCenter = NotificationCenter.default
  
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
  
  private var chatInputView = ChatInputView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    hideKeyboard()
    setupCollectionView()
    configureUI()
    setupConstraints()
    bind()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    input.send(
      .sendButtonTapped(
        message: Message(
          role: "user",
          content: "Compose a poem that explains the concept of recursion in programming."
        )
      )
    )
  }
}

private extension ChatBotViewController {
  func hideKeyboard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
      return
    }
    
    self.view.frame.origin.y = 0 - keyboardSize.height
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    self.view.frame.origin.y = 0
  }
  
  func configureUI() {
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
        chatCollectionView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor),
        
        chatInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        chatInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        chatInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          self?.chatCollectionView.srollToBottom()
        }
      case .toggleSendButton(let isEnable):
        print("\(isEnable)")
      }
    }
    .store(in: &cancellable)
  }
  
  func applyChatResponse(response: RequestModel) {
    var chatCollectionViewSnapshot = ChatCollectionViewSnapshot()
    chatCollectionViewSnapshot.appendSections([.messages])
    chatCollectionViewSnapshot.appendItems(response.messages)
    dataSource.apply(chatCollectionViewSnapshot)
  }
}
