import XCTest
@testable import ChatBot

final class OpenAIChatRequestBodyDTOTests: XCTestCase {
    
    private var jsonEncoder: JSONEncoder? = nil
    
    override func setUpWithError() throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.jsonEncoder = encoder
    }

    override func tearDownWithError() throws {
        self.jsonEncoder = nil
    }
    
    func test_DTO에_정의된_속성들이_JSON으로_encoding될_때_에러가_발생하지_않는다() throws {
        // given
        let model = "Test"
        let stream = false
        let messages = [ChatCompletionRequestDTO.Message(role: "yuni", content: "Hello")]
        let expectedDTO = ChatCompletionRequestDTO(model: model, stream: stream, messages: messages)
        
        // when
        let encodedData = try jsonEncoder?.encode(expectedDTO)
        
        // then
        XCTAssertNoThrow(encodedData)
    }
}
