//
//  GPTChattingVMTests.swift
//  ChatBotTests
//
//  Created by 김준성 on 1/26/24.
//

import Combine
import Foundation
import XCTest

@testable import ChatBot

final class GPTChattingVMTests: XCTestCase {
    let chatRoom = Model.GPTChatRoomDTO(title: "test", recentChatDate: Date())
    var publisher: StubGPTHTTPPublisher!
    var viewModel: GPTChattingVMProtocol!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        publisher = StubGPTHTTPPublisher(isNotError: true)
        let service = Network.GPTHTTPService(publisher: publisher, encoder: JSONEncoder(), decoder: JSONDecoder())
        viewModel = GPTChattingViewModel(chatRoomDTO: chatRoom, httpService: service, httpRequest: Network.GPTRequest.chatBot(apiKey: "test"))
        cancellables = Set()
    }
    
    override func tearDownWithError() throws {
        publisher = nil
        viewModel = nil
        cancellables = nil
    }
    
    func test_네트워크_통신을_통해_채팅을_기존_배열에_더해서_배열의_개수를_하나_늘린다() {
        // given
        publisher.isNotError = true
        
        // expect
        let messagesCount = 2
        
        viewModel.updateChattings
            .sink { (messages: [Model.GPTMessage], indexToUpdate: Int) in
                // then(Success)
                XCTAssertEqual(messagesCount, messages.count)
            }
            .store(in: &cancellables)
        
        viewModel.error
            .sink { error in
                // then(Fail)
                XCTFail(error.localizedDescription)
            }
            .store(in: &cancellables)
        
        // when
        viewModel.sendChat("123")
    }
    
    func test_네트워크_통신이_에러가_났을_때_에러를_sink_받는다() {
        publisher.isNotError = false
        
        // expect
        let expectedError = GPTError.HTTPError.invalidURL
        
        viewModel.error
            .sink { error in
                // then(Success)
                XCTAssertEqual(expectedError.localizedDescription, error.localizedDescription)
            }
            .store(in: &cancellables)
        
        // when
        viewModel.sendChat("123")
    }
}
