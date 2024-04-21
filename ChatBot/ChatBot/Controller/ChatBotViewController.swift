//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import UIKit
import Combine

final class ChatBotViewController: UIViewController {
  
  private let chatBotViewModel: ChatViewModel = .init()
  private let chattingView: ChattingView = .init()
  private var cancellable: Set<AnyCancellable> = .init()
  private let input: PassthroughSubject<ChatViewModel.Input, Never> = .init()
  
  override func loadView() {
    super.loadView()
    self.view = chattingView
    setupKeyboardNotification()
    bind()
    setupChatInputView()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

private extension ChatBotViewController {
  func setupChatInputView() {
    chattingView.setChatSendButton { [weak self] message in
      self?.input.send(.sendButtonTapped(message: message))
      guard let requestDTO = self?.chatBotViewModel.requestDTO else { return }
      self?.chattingView.applyChatResponse(response: requestDTO)
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
        self?.chattingView.applyChatResponse(response: response)
      case .toggleSendButton(let isEnable):
        self?.chattingView.isSendButtonEnable(isEnable)
      }
    }
    .store(in: &cancellable)
  }
}
