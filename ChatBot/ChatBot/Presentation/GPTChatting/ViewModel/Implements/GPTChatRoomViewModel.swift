//
//  GPTChatRoomViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Combine

final class GPTChatRoomViewModel: GPTChatRoomVMProtocol {
    private let httpService: HTTPServicable
    private let httpRequest: HTTPRequestable
    
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var messages = [Model.GPTMessage]()
    
    init(httpService: HTTPServicable = AppEnviroment.defaultHTTPSecvice, httpRequest: HTTPRequestable) {
        self.httpService = httpService
        self.httpRequest = httpRequest
    }
    
    func transform(from input: GPTChatRoomInput) -> AnyPublisher<GPTChatRoomOutput, Never> {
        input.sendingComment
            .sink { [weak self] comment in
                guard let self else { return }
                guard let comment = comment, !comment.isEmpty else {
                    output.send(Output.failure(GPTError.ChatRoomError.emptyUserComment))
                    return
                }
                messages.append(Model.UserMessage(content: comment).asRequestMessage())
                messages.append(Model.WaitingMessage().asRequestMessage())
                output.send(Output.success(messages: messages, indexToUpdate: messages.count - 1))
                getReplyFromServer(messages.count - 1)
            }
            .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func getReplyFromServer(_ indexToUpdate: Int) {
        let networkPublisher = httpService.request(
            request: httpRequest,
            object: Model.GPTCommentDTO(messages: messages.filter { $0.role != .waiting }),
            type: Model.GPTReplyDTO.self
        ).tryMap { replyDTO in
            guard let reply = replyDTO.choices.first?.message else {
                throw GPTError.ChatRoomError.emptyGPTReply
            }
            return reply
        }
        
        var cancellable: AnyCancellable! = nil
        cancellable = networkPublisher
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    messages[indexToUpdate] = Model.AssistantMessage(content: error.localizedDescription, name: nil, toolCalls: nil).asRequestMessage()
                    output.send(Output.failure(error))
                case .finished:
                    output.send(Output.success(messages: messages, indexToUpdate: indexToUpdate))
                }
                cancellables.remove(cancellable)?.cancel()
            } receiveValue: { [weak self] message in
                guard let self else { return }
                messages[indexToUpdate] = message
            }
        cancellable?.store(in: &cancellables)
    }
}
