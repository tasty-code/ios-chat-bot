//
//  ChatDTOUnitTests.swift
//  ChatBotUnitTests
//
//  Created by ㅣ on 3/27/24.
//

import XCTest
@testable import ChatBot

final class ChatDTOUnitTests: BaseTestCase {

    var sut: ChatRequestDTO!
    
    override func setUpWithError() throws {
        super.setUp()
        let messages = [ChatMessageDTO(role: "user", content: "Hello!")]
        sut = ChatRequestDTO(messages: messages)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
}

extension ChatDTOUnitTests {
    func test_GivenValidChatRequestDTO_WhenEncoding_ThenModelAndStreamMatchExpectation() {
        var actualDictionary: [String: Any]!
        
        when {
            do {
                let data = try JSONEncoder().encode(sut)
                actualDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch {
                XCTFail("인코딩 실패 \(error)")
            }
        }
        
        then {
            XCTAssertEqual(actualDictionary?["model"] as? String, "gpt-3.5-turbo-1106")
            XCTAssertEqual(actualDictionary?["stream"] as? Bool, false)
        }
    }
}
