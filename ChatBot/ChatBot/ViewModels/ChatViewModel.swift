//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Janine on 1/15/24.
//

import Foundation
import Combine

final class ChatViewModel {
    enum Output {
        case fetchChatDidStart(isNetworking: Bool)
        case fetchChatDidSucceed
    }
    
    private(set) var messages: [ChatMessage]
    private var cancellables = Set<AnyCancellable>()
    
    let userInputMessage: PassthroughSubject<String, Never> = .init()
    private let answerMessage: PassthroughSubject<Output, Never> = .init()
    
    private(set) var isNetworking = false
    
    // MARK: - Life cycle
    init(messages: [ChatMessage] = []) {
        self.messages = messages
    }
    
    func subscribeAnswer() -> AnyPublisher<Output, Never> {
        userInputMessage
            .handleEvents(receiveOutput: { [weak self] message in
                self?.messages.append(ChatMessage(role: .user, content: message))
            })
            .tryMap { [weak self] _ -> URLRequest in
                guard let messages = self?.messages else {
                    throw APIError.invalidRequest(message: "잘못된 메시지입니다")
                }
                
                let builder = PostChatBotNetworkBuilder(message: messages)
                guard let request = try? APIService.shared.makeRequest(builder) else {
                    throw APIError.invalidRequest(message: "invalid request")
                }
                
                self?.isNetworking = true
                self?.answerMessage.send(.fetchChatDidStart(isNetworking: true))
                
                return request
            }
            .flatMap { request in
                APIService.shared.execute(request: request) as AnyPublisher<ChatResponse, Error>
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("error occured: \(failure.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                let content = response.choices[0].message.content
                self?.messages.append(ChatMessage(role: .assistant, content: content))
                
                self?.isNetworking = false
                self?.answerMessage.send(.fetchChatDidSucceed)
            })
            .store(in: &cancellables)
        
        return answerMessage.eraseToAnyPublisher()
    }
    
    // MARK: - Public
    func getMessage(at index: Int) -> ChatMessage? {
        messages[safeIndex: index]
    }
    
    func getChatMessageCount() -> Int {
        isNetworking ? messages.count + 1 : messages.count
    }
}
