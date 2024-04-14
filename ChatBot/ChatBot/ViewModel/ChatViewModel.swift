//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by 강창현 on 4/3/24.
//

import Foundation
import Combine

final class ChatViewModel {
  private var requestModel: RequestModel?
  private let networkService: NetworkService
  private let output: PassthroughSubject<Output, Never> = .init()
  private var cancellables: Set<AnyCancellable> = .init()
  var requestDTO: [RequestDTO] = []
  
  enum Input {
    case sendButtonTapped(message: Message)
  }
  
  enum Output {
    case fetchChatResponseDidFail(error: NetworkError)
    case fetchChatResponseDidSucceed(response: [RequestDTO])
    case toggleSendButton(isEnable: Bool)
  }
  
  init(networkService: NetworkService = NetworkService()) {
    self.networkService = networkService
  }
  
  func transform(input: AnyPublisher<Input,Never>) -> AnyPublisher<Output,Never> {
    input.sink { [weak self] event in
      switch event {
      case .sendButtonTapped(let message):
        guard let body = self?.makeBody(message: message) else { return }
        self?.fetchChatBotData(body: body)
      }
    }.store(in: &cancellables)
    return output.eraseToAnyPublisher()
  }
}

private extension ChatViewModel {
  func fetchChatBotData(body: RequestModel) {
    self.output.send(.toggleSendButton(isEnable: false))
    networkService.fetchChatBotResponse(
      type: .chatbot,
      httpMethod: .POST(body: body)
    )
    .sink { [weak self] completion in
      switch completion {
      case .finished:
        self?.output.send(.toggleSendButton(isEnable: true))
      case .failure(let error):
        self?.output.send(.fetchChatResponseDidFail(error: error))
      }
    } receiveValue: { [weak self] response in
      self?.requestDTO.removeLast()
      self?.requestDTO.append(
        RequestDTO(
          id: UUID(),
          message: response.choices[0].message
        )
      )
      guard let requestDTO = self?.requestDTO else { return }
      self?.output.send(.fetchChatResponseDidSucceed(response: requestDTO))
    }
    .store(in: &cancellables)
  }
  
  func makeBody(message: Message) -> RequestModel? {
    let responseMessage = Message(role: "assistant", content: "● ● ●")
    guard
      requestModel != nil
    else {
      requestModel = RequestModel(
        messages: [
          Message(
            role: "system",
            content: "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."
          ),
          message
        ]
      )
      setRequestDTO(message, responseMessage)
      return requestModel
    }
    setRequestDTO(message, responseMessage)
    return requestModel
  }
  
  func setRequestDTO(_ message: Message, _ responseMessage: Message) {
    requestDTO.append(
      RequestDTO(id: UUID(), message: message)
    )
    requestDTO.append(
      RequestDTO(id: UUID(), message: responseMessage)
    )
  }
}

