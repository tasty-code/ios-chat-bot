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
    
    enum Input {
        case sendButtonTapped(message: Message)
    }

    enum Output {
        case fetchChatResponseDidFail(error: NetworkError)
        case fetchChatResponseDidSucceed(response: ResponseModel)
        case toggleSendButton(isEnable: Bool)
    }
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func transform(input: AnyPublisher<Input,Never>) -> AnyPublisher<Output,Never> {
        input.sink { [weak self] event in
            switch event {
            case .sendButtonTapped(let message):
                self?.fetchChatBotData(message: message)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

private extension ChatViewModel {
    func fetchChatBotData(message: Message) {
        let body = makeBody(message: message)
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
            self?.output.send(.fetchChatResponseDidSucceed(response: response))
        }
        .store(in: &cancellables)
    }
    
    func makeBody(message: Message) -> RequestModel? {
        guard
            requestModel != nil
        else {
            requestModel = RequestModel(
                messages: [
                    Message(role: "system", content: "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."),
                    message
                ]
            )
            return requestModel
        }
        requestModel?.messages.append(message)
        return requestModel
    }
}
