//
//  GPTChattingViewModel.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Combine

final class GPTChattingViewModel {
    private let chatRoomDTO: Model.GPTChatRoomDTO
    private let chattingRepository: ChattingRepositable
    private let promptSettingRepository: PromptSettingRepositable
    
    private let httpService: HTTPServicable
    private let httpRequest: HTTPRequestable
    
    private let updateChattingsSubject = PassthroughSubject<(messages: [Model.GPTMessage], indexToUpdate: Int), Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var systemMessage: Model.GPTMessage?
    private var messages = [Model.GPTMessage]()
    
    init(
        chatRoomDTO: Model.GPTChatRoomDTO,
        chattingRepository: ChattingRepositable = Repository.CoreDataChattingRepository(),
        promptSettingRepository: PromptSettingRepositable = Repository.CoreDataPromptSettingRepository(),
        httpService: HTTPServicable = AppEnviroment.defaultHTTPSecvice,
        httpRequest: HTTPRequestable
    ) {
        self.chatRoomDTO = chatRoomDTO
        self.chattingRepository = chattingRepository
        self.httpService = httpService
        self.httpRequest = httpRequest
        self.promptSettingRepository = promptSettingRepository
    }
    
    private func getReplyFromServer(_ indexToUpdate: Int) {
        var sendMessage = messages.filter { $0.role != .waiting }
        if let systemMessage = systemMessage {
            sendMessage = [systemMessage] + sendMessage
        }
        
        let networkPublisher = httpService.request(
            request: httpRequest,
            object: Model.GPTCommentDTO(messages: sendMessage),
            type: Model.GPTReplyDTO.self
        ).tryMap { replyDTO in
            guard let reply = replyDTO.choices.first?.message else {
                throw GPTError.ChatRoomError.emptyGPTReply
            }
            return reply
        }
        
        var cancellable: AnyCancellable = AnyCancellable{ }
        cancellable = networkPublisher
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    messages[indexToUpdate] = Model.AssistantMessage(content: error.localizedDescription, name: nil, toolCalls: nil).asRequestMessage()
                    errorSubject.send(error)
                case .finished:
                    updateChattingsSubject.send((messages, indexToUpdate))
                }
                cancellables.remove(cancellable)?.cancel()
            } receiveValue: { [weak self] message in
                guard let self else { return }
                messages[indexToUpdate] = message
            }
        cancellable.store(in: &cancellables)
    }
}

extension GPTChattingViewModel: GPTChattingOutput {
    var updateChattings: AnyPublisher<(messages: [Model.GPTMessage], indexToUpdate: Int), Never> { updateChattingsSubject.eraseToAnyPublisher() }
    var error: AnyPublisher<Error, Never> { errorSubject.eraseToAnyPublisher() }
}

extension GPTChattingViewModel: GPTChattingsInput {
    func onViewDidLoad() { }
    
    func onViewWillAppear() {
        do {
            systemMessage = try promptSettingRepository.fetchPromptSetting(for: chatRoomDTO)?.asRequestMessage()
            messages = try chattingRepository.fetchChattings(for: chatRoomDTO)
            if messages.isEmpty { return }
            updateChattingsSubject.send((messages, messages.count - 1))
        } catch {
            errorSubject.send(error)
        }
    }
    
    func onViewWillDisappear() {
        try? chattingRepository.storeChattings(messages, for: chatRoomDTO)
    }
    
    func sendChat(_ content: String?) {
        guard let content = content, !content.isEmpty else {
            errorSubject.send(GPTError.ChatRoomError.emptyUserComment)
            return
        }
        messages.append(Model.UserMessage(content: content).asRequestMessage())
        messages.append(Model.WaitingMessage().asRequestMessage())
        updateChattingsSubject.send((messages: messages, indexToUpdate: messages.count - 1))
        
        getReplyFromServer(messages.count - 1)
    }
}
