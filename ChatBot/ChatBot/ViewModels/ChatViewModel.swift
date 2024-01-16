//
//  ChatViewModel.swift
//  ChatBot
//
//  Created by Janine on 1/15/24.
//

import Foundation
import Combine

final class ChatViewModel {
    enum InputEvent {
        case sendButtonDidTap(prompt: String)
    }
    
    enum Output {
        case fetchChatDidFail(error: Error)
        case fetchChatDidSucceed(result: Decodable)
    }
    
    private(set) var messages: [Message]
    private var cancellables = Set<AnyCancellable>()
    private let output: PassthroughSubject<Output, Never> = .init()
    
    // MARK: - Life cycle
    init(messages: [Message] = [ConstantsForNetworkRequest.defaultMessage]) {
        self.messages = messages
    }
    
    func transform(input: AnyPublisher<InputEvent, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .sendButtonDidTap(let prompt):
                self?.messages.append(Message(role: .user, content: prompt))
                self?.handleRequest()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleRequest() {
        let builder = PostChatBotNetworkBuilder(message: messages)
        guard let request = try? APIService.shared.makeRequest(builder) else { return }
        Task(priority: .background) {
            let data: Result<APIResponse, Error> = try await APIService.shared.execute(request: request)
            
            guard case .success(let response) = data else {
                return
            }
            
            let content = response.choices[0].message.content
            messages.append(Message(role: .assistant, content: content))
            
            print("🔔", content)
            
            output.send(.fetchChatDidSucceed(result: content))
        }
    }
    
    // MARK: - Public
    func getMessage(at index: Int) -> Message {
        messages[index]
    }
}
