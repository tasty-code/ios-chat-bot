import Foundation
import Combine

enum ChatRoomModelError: Error, Equatable {
    case chattingFetch
}

enum ChatRoomModelState: Equatable {
    case loading
    case finishedLoading
    case error(ChatRoomModelError)
}

final class ChatRoomViewModel {
    @Published private(set) var comments: [ChatRoomModel] = []
    @Published private(set) var state: ChatRoomModelState = .finishedLoading
    private var requestMessage: [Message] = [Message(role: .system, content:
    "질문은 유저와 GPT가 나눈 대화 이력이 들어있습니다. 항상 마지막 질문이 지금 물어보는 것이니 이전 기록을 잘 참고해서 자연스럽게 대화를 이어가주세요. 마치 오랜 친구처럼요", toolCalls: nil)]
    
    private let mapper: Mappable
    private var bindings = Set<AnyCancellable>()
    
    init(mapper: Mappable = Mapper(dataDecoder: DataDecoder(networkManager: NetworkManager()))) {
        self.mapper = mapper
    }
    
    func askQuestion(query: String, history: String) {
        fetchData(with: query, of: history)
    }
}

//네트워크 데이터 가져오는 부분
extension ChatRoomViewModel {
    private func fetchData(with question: String?, of history: String?) {
        state = .loading
        guard let question = question, let history = history else { return }
        
        self.comments.append(contentsOf: [ChatRoomModel(content: question, role: .user)])
        
        let questionCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self]
            completion in
            switch completion {
            case .failure:
                self?.state = .error(.chattingFetch)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let questionValueHander: ([ChatRoomModel]) -> Void = { [weak self] messages in
            self?.comments.append(contentsOf: messages)
        }
    
        requestMessage.append(Message(role: .user, content: history, toolCalls: nil))
        
        mapper.mapChatGPTContent(with: requestMessage)
            .sink(receiveCompletion: questionCompletionHandler, receiveValue: questionValueHander)
            .store(in: &bindings)
    }
}
