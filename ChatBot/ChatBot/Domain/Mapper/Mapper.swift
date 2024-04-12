import Foundation
import Combine

final class Mapper: Mappable {
    private let dataDecoder: DataDecodable
    
    init(dataDecoder: DataDecodable) {
        self.dataDecoder = dataDecoder
    }
    
    func mapChatGPTContent(with messages: [Message]) -> AnyPublisher<[ChatRoomModel], Error> {
        return dataDecoder.decodedChatGPTCompletionData(with: messages, type: GPTResponseDTO.self)
            .receive(on: RunLoop.main)
            .map { result in
                print(result)
                return [ChatRoomModel(content: result.choices[0].message.content, role: result.choices[0].message.role)]
            }
            .eraseToAnyPublisher()
    }
}
