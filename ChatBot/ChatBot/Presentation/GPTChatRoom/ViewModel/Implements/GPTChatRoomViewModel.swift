//
//  GPTChatRoomViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Foundation
import Combine

final class GPTChatRoomViewModel: GPTChatRoomVMProtocol {
    private let httpService: HTTPServicable
    private let httpRequest: HTTPRequestable
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var chattings: [GPTMessagable]
    var chattingsPublisher: Published<[GPTMessagable]>.Publisher { $chattings }
    
    init(httpService: HTTPServicable, httpRequest: HTTPRequestable, chattings: [Model.GPTMessage]) {
        self.httpService = httpService
        self.httpRequest = httpRequest
        self.chattings = chattings
    }
    
    func sendComment(_ comment: GPTMessagable) {
        chattings.append(comment.asRequestMessage())
        
        httpService.request(
            request: httpRequest,
            object: Model.GPTCommentDTO(messages: chattings),
            type: Model.GPTReplyDTO.self
        )
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.chattings.append(Model.AssistantMessage(content: error.localizedDescription, name: nil, toolCalls: nil))
            }
        } receiveValue: { [weak self] reply in
            guard let bestMessage = reply.choices.first?.message else {
                self?.chattings.append(Model.AssistantMessage(content: "내용이 없습니다...", name: nil, toolCalls: nil))
                return
            }
            self?.chattings.append(bestMessage)
        }
        .store(in: &cancellables)
    }
}
