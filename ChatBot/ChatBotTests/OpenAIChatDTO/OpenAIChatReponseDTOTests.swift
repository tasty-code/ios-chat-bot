import XCTest
@testable import ChatBot

final class OpenAIChatReponseDTOTests: XCTestCase {
    private let sut: OpenAI.Chat.ResponseDTO.Type = OpenAI.Chat.ResponseDTO.self
    
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
        let targetBundle = Bundle(for: OpenAIChatReponseDTOTests.self)
        let data: Data = try JSONLoader(bundle: targetBundle).loadJSON(fileName: fileName)
        
        // when
        let result = try self.jsonDecoder?.decode(sut, from: data)
        
        // then
        XCTAssertNoThrow(result)
    }
}
