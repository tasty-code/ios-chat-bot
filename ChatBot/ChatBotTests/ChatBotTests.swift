//
//  ChatBotTests.swift
//  ChatBotTests
//
//  Created by 김준성 on 1/9/24.
//

import XCTest

@testable import ChatBot

final class ChatBotTests: XCTestCase {
    var httpService: HTTPServicable!
    
    override func setUpWithError() throws {
        httpService = Network.GPTHTTPService(publisher: MockHTTPPublisher(), encoder: JSONEncoder(), decoder: JSONDecoder())
    }

    override func tearDownWithError() throws {
        httpService = nil
    }

    func test_GPTCommentDTO를_Data로_인코딩하여_요청을_보낸다() throws {
        // given
        let httpRequest = MockHTTPRequest()
        let expectedModel = JSONFetcher.load(type: Model.GPTReplyDTO.self, fileName: "GPTReplyMock")!
        let encodeObject = Model.GPTCommentDTO(
            messages: [Model.UserMessage(content: "안녕?")]
        )
        
        // when
        _ = httpService.request(request: httpRequest, object: encodeObject, type: Model.GPTReplyDTO.self)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    //then
                    print(">>>>> \(error)")
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { reply in
                //then
                XCTAssertEqual(reply.id, expectedModel.id)
            })
    }
    
    func test_Data를_GPTReplyDTO로_디코딩하여_응답으로_타입을_받는다() throws {
        // given
        let expectedModel = JSONFetcher.load(type: Model.GPTReplyDTO.self, fileName: "GPTReplyMock")!
        let httpRequest = MockHTTPRequest()
        
        // when
        _ = httpService.request(request: httpRequest, type: ChatBot.Model.GPTReplyDTO.self)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    //then
                    print(">>>>> \(error)")
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { reply in
                //then
                XCTAssertEqual(reply.id, expectedModel.id)
            })
    }
    
    func test_Data를_GPTReplyDTO로_디코딩하여_응답으로_오류를_받는다() throws {
        // given
        let httpRequest = MockHTTPRequest()
        
        // when
        _ = httpService.request(request: httpRequest, type: Int.self)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    //then
                    if let _ = error as? Swift.DecodingError {
                        XCTAssertTrue(true)
                    }
                }
            }, receiveValue: { reply in
                //then
                print(reply)
                XCTFail("디코딩이 성공하면 안됨.")
            })
    }
}
