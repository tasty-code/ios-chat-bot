import XCTest
@testable import ChatBot

final class ChatCompletionReponseDTOTests: XCTestCase {
    private let sut: ChatCompletionReponseDTO.Type = ChatCompletionReponseDTO.self
    
    private var jsonDecoder: JSONDecoder? = nil
    
    override func setUpWithError() throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder = decoder
    }
    
    override func tearDownWithError() throws {
        self.jsonDecoder = nil
    }
    
    func test_주어진json데이터를_decoder를_이용해_ChatCompletionReponseDTO타입으로_decoding할때_에러를_던지지_않는다() throws {
        // given
        let fileName = "chat-completion-response-sample"
        let data: Data = try JSONLoader.loadJSON(fileName: fileName)
        
        // when
        let result = try self.jsonDecoder?.decode(sut, from: data)
        
        // then
        XCTAssertNoThrow(result)
    }
}
