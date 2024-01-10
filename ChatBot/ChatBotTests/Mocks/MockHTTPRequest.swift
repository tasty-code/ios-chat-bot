//
//  MockHTTPRequest.swift
//  ChatBotTests
//
//  Created by 김준성 on 1/9/24.
//

import Foundation

@testable import ChatBot

final class MockHTTPRequest: HTTPRequestable {
    let urlString: String? = "GPTReplyMock"
    let httpMethod: ChatBot.Network.HTTPMethod = .get
    
    func configureURL() -> URL? {
        try? JSONFetcher.fileURL(of: urlString!)
    }
}
