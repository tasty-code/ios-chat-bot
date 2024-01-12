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
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var chattings: [Model.GPTMessage]
    var chattingsPublisher: Published<[Model.GPTMessage]>.Publisher { $chattings }
    
    init(httpService: HTTPServicable, httpRequest: HTTPRequestable, chattings: [Model.GPTMessage]) {
        self.httpService = httpService
        self.httpRequest = httpRequest
        self.chattings = chattings
    }
    
    func sendComment(_ comment: GPTMessagable) {
        chattings.append(comment.asRequestMessage())
        let index = chattings.count
        chattings.append(Model.WaitingMessage().asRequestMessage())
        
        httpService.request(
            request: httpRequest,
            object: Model.GPTCommentDTO(messages: chattings.filter { $0.role != .waiting }),
            type: Model.GPTReplyDTO.self
        )
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.chattings[index] = Model.AssistantMessage(content: "\(error)", name: nil, toolCalls: nil).asRequestMessage()
            }
        } receiveValue: { [weak self] reply in
            guard let bestMessage = reply.choices.first?.message else {
                self?.chattings[index] = Model.AssistantMessage(content: "내용이 없습니다...", name: nil, toolCalls: nil).asRequestMessage()
                return
            }
            self?.chattings[index] = Model.AssistantMessage(content: bestMessage.content, name: nil, toolCalls: nil).asRequestMessage()
        }
        .store(in: &cancellables)
    }
}
