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
  private var cancellable = Set<AnyCancellable>()
  private let input: PassthroughSubject<ChatViewModel.Input, Never> = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
  func bind() {
    let output = chatBotViewModel.transform(
      input: input.eraseToAnyPublisher()
    )
    output.sink { event in
      switch event {
      case .fetchChatResponseDidFail(let error):
        print(error.localizedDescription)
      case .fetchChatResponseDidSucceed(let response):
        print(response.choices[0].message.content)
      case .toggleSendButton(let isEnable):
        print("\(isEnable)")
      }
    }
    .store(in: &cancellable)
  }
}
