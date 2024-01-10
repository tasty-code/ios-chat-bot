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

    func test_코멘트_요청에_대한_인코딩이_제대로_되는지() throws {
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
    
    func test_챗봇_응답에_대한_디코딩이_제대로_되는지() throws {
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
    
    func test_챗봇_응답에_대한_디코딩이_안될_때_오류를_제대로_만드는지() throws {
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
